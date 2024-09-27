from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
from sqlalchemy import create_engine, Column, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
import uuid
from dotenv import load_dotenv
import os
from azure.servicebus import ServiceBusClient, ServiceBusMessage

app = FastAPI()

# Allow CORS for all origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# PostgreSQL configuration
load_dotenv()
PG_USER = os.getenv("PG_USER")
PG_PASSWORD = os.getenv("PG_PASSWORD")
PG_DB = os.getenv("PG_DB")
PG_HOST = os.getenv("PG_HOST")
PG_PORT = os.getenv("PG_PORT")

PG_CONNECTION_STRING = f"postgresql+psycopg2://{PG_USER}:{PG_PASSWORD}@{PG_HOST}:{PG_PORT}/{PG_DB}"

# Initialize SQLAlchemy
engine = create_engine(PG_CONNECTION_STRING)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class TodoItemDB(Base):
    __tablename__ = "todos"
    id = Column(String, primary_key=True, index=True)
    label = Column(String, index=True)
    description = Column(String)
    ai_recommendation = Column(String)
    state = Column(String, index=True)
    due_date = Column(DateTime)


Base.metadata.create_all(bind=engine)


class TodoItem(BaseModel):
    id: Optional[str] = None
    label: str
    description: str
    ai_recommendation: Optional[str] = None
    state: str
    due_date: datetime


# Azure Service Bus configuration
SERVICE_BUS_CONNECTION_STRING = os.getenv("SERVICE_BUS_CONNECTION_STRING")
SERVICE_BUS_TOPIC_NAME = os.getenv("SERVICE_BUS_TOPIC_NAME")


def send_message_to_service_bus(todo_item: TodoItem):
    servicebus_client = ServiceBusClient.from_connection_string(
        SERVICE_BUS_CONNECTION_STRING)
    with servicebus_client:
        sender = servicebus_client.get_topic_sender(topic_name=SERVICE_BUS_TOPIC_NAME)
        with sender:
            message = ServiceBusMessage(todo_item.json())
            sender.send_messages(message)


@app.post("/api/todos/", response_model=TodoItem)
async def create_todo_item(todo: TodoItem, db: Session = Depends(get_db)):
    todo.id = str(uuid.uuid4())
    db_item = TodoItemDB(**todo.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    send_message_to_service_bus(todo)
    return db_item


@app.get("/api/todos/", response_model=List[TodoItem])
async def read_todo_items(db: Session = Depends(get_db)):
    return db.query(TodoItemDB).all()


@app.get("/api/todos/{todo_id}", response_model=TodoItem)
async def read_todo_item(todo_id: str, db: Session = Depends(get_db)):
    db_item = db.query(TodoItemDB).filter(TodoItemDB.id == todo_id).first()
    if db_item is None:
        raise HTTPException(status_code=404, detail="Todo item not found")
    return db_item


@app.put("/api/todos/{todo_id}", response_model=TodoItem)
async def update_todo_item(todo_id: str, todo: TodoItem, db: Session = Depends(get_db)):
    db_item = db.query(TodoItemDB).filter(TodoItemDB.id == todo_id).first()
    if db_item is None:
        raise HTTPException(status_code=404, detail="Todo item not found")
    for key, value in todo.dict(exclude_unset=True).items():
        setattr(db_item, key, value)
    db.commit()
    db.refresh(db_item)
    return db_item


@app.delete("/api/todos/{todo_id}")
async def delete_todo_item(todo_id: str, db: Session = Depends(get_db)):
    db_item = db.query(TodoItemDB).filter(TodoItemDB.id == todo_id).first()
    if db_item is None:
        raise HTTPException(status_code=404, detail="Todo item not found")
    db.delete(db_item)
    db.commit()
    return {"message": "Todo item deleted successfully"}
