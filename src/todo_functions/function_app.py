from pydantic import BaseModel, ValidationError
from typing import List, Optional
from datetime import datetime
from sqlalchemy import create_engine, Column, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from dotenv import load_dotenv
import os
import azure.functions as func
import logging
import uuid
import json
from openai import AzureOpenAI

# Configurations
load_dotenv()
PG_USER = os.getenv("PG_USER")
PG_PASSWORD = os.getenv("PG_PASSWORD")
PG_DB = os.getenv("PG_DB")
PG_HOST = os.getenv("PG_HOST")
PG_PORT = os.getenv("PG_PORT")

PG_CONNECTION_STRING = f"postgresql+psycopg2://{PG_USER}:{PG_PASSWORD}@{PG_HOST}:{PG_PORT}/{PG_DB}"

SERVICE_BUS_TOPIC_NAME = os.getenv("SERVICE_BUS_TOPIC_NAME")
SERVICE_BUS_SUBSCRIBER_NAME = os.getenv("SERVICE_BUS_SUBSCRIBER_NAME")  

AZURE_OPENAI_API_KEY = os.getenv("AZURE_OPENAI_API_KEY")
AZURE_OPENAI_ENDPOINT = os.getenv("AZURE_OPENAI_ENDPOINT")
AZURE_OPENAI_DEPLOYMENT = os.getenv("AZURE_OPENAI_DEPLOYMENT")

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

# Instantiate DB client
db = next(get_db())

# Instantiate OpenAI client
client = AzureOpenAI(
    api_key=AZURE_OPENAI_API_KEY,
    api_version="2024-02-01",
    azure_endpoint=AZURE_OPENAI_ENDPOINT
)

# Instantiate the Function App
app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

####################
# Create a todo item
####################
@app.route(route="todos", methods=["POST"], auth_level=func.AuthLevel.ANONYMOUS)
@app.service_bus_topic_output(arg_name="message",
                              connection="SERVICE_BUS_CONNECTION_STRING",
                              topic_name=SERVICE_BUS_TOPIC_NAME)
def create_todo_item(req: func.HttpRequest, message: func.Out[str]) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request to create a todo.')
    try:
        req_body = req.get_json()
        req_body['id'] = str(uuid.uuid4())
        db_item = TodoItemDB(**req_body)
        
        db.add(db_item)
        db.commit()
        db.refresh(db_item)

        # Return the created todo document as JSON
        message.set(json.dumps(req_body))
        return func.HttpResponse(
            body=json.dumps(req_body),
            status_code=201,
            headers={"Content-Type": "application/json"}
        )
    
    except ValidationError as e:
        return func.HttpResponse(
            body=json.dumps({"error": "Invalid data", "details": e.errors()}),
            status_code=400,
            headers={"Content-Type": "application/json"}
        )
    except ValueError:
        return func.HttpResponse(
            body=json.dumps({"error": "Invalid JSON in request body"}),
            status_code=400,
            headers={"Content-Type": "application/json"}
        )
    except Exception as e:
        logging.error(f"Error creating todo: {str(e)}")
        return func.HttpResponse(
            body=json.dumps({"error": "An error occurred while creating todo", "details": str(e)}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        )
    
####################
# Delete a todo item
####################
@app.route(route="todos/{id}", methods=["DELETE"], auth_level=func.AuthLevel.ANONYMOUS)
def delete_todo_item(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request to delete a todo.')
    try:
        id = req.route_params.get('id')
        db_item = db.query(TodoItemDB).filter(TodoItemDB.id == id).first()
        if db_item is None:
            return func.HttpResponse(
                body=json.dumps({"error": "Todo item not found"}),
                status_code=404,
                headers={"Content-Type": "application/json"}
            )
        
        db.delete(db_item)
        db.commit()

        return func.HttpResponse(
            status_code=204
        )
    
    except Exception as e:
        logging.error(f"Error deleting todo: {str(e)}")
        return func.HttpResponse(
            body=json.dumps({"error": "An error occurred while deleting todo", "details": str(e)}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        )
    
####################
# Get all todo items
####################
@app.route(route="todos", methods=["GET"], auth_level=func.AuthLevel.ANONYMOUS)
def read_todo_items(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request to get all todos.')
    try:
        todos = db.query(TodoItemDB).all()
        todo_list = []
        for todo in todos:
            todo_list.append({
                "id": todo.id,
                "label": todo.label,
                "description": todo.description,
                "ai_recommendation": todo.ai_recommendation,
                "state": todo.state,
                "due_date": todo.due_date.isoformat()
            })
        return func.HttpResponse(
            body=json.dumps(todo_list),
            status_code=200,
            headers={"Content-Type": "application/json"}
        )
    
    except Exception as e:
        logging.error(f"Error getting todos: {str(e)}")
        return func.HttpResponse(
            body=json.dumps({"error": "An error occurred while getting todos", "details": str(e)}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        )
    
####################
# Get a todo item
####################
@app.route(route="todos/{id}", methods=["GET"], auth_level=func.AuthLevel.ANONYMOUS)
def read_todo_item(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request to get a todo.')
    try:
        id = req.route_params.get('id')
        db_item = db.query(TodoItemDB).filter(TodoItemDB.id == id).first()
        if db_item is None:
            return func.HttpResponse(
                body=json.dumps({"error": "Todo item not found"}),
                status_code=404,
                headers={"Content-Type": "application/json"}
            )
        
        todo = {
            "id": db_item.id,
            "label": db_item.label,
            "description": db_item.description,
            "ai_recommendation": db_item.ai_recommendation,
            "state": db_item.state,
            "due_date": db_item.due_date.isoformat()
        }
        return func.HttpResponse(
            body=json.dumps(todo),
            status_code=200,
            headers={"Content-Type": "application/json"}
        )
    
    except Exception as e:
        logging.error(f"Error getting todo: {str(e)}")
        return func.HttpResponse(
            body=json.dumps({"error": "An error occurred while getting todo", "details": str(e)}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        )
    
####################
# Update a todo item
####################
@app.route(route="todos/{id}", methods=["PUT"], auth_level=func.AuthLevel.ANONYMOUS)
def update_todo_item(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request to update a todo.')
    try:
        id = req.route_params.get('id')
        req_body = req.get_json()
        db_item = db.query(TodoItemDB).filter(TodoItemDB.id == id).first()
        if db_item is None:
            return func.HttpResponse(
                body=json.dumps({"error": "Todo item not found"}),
                status_code=404,
                headers={"Content-Type": "application/json"}
            )
        
        for key, value in req_body.items():
            setattr(db_item, key, value)
        db.commit()
        db.refresh(db_item)

        return func.HttpResponse(
            body=json.dumps(req_body),
            status_code=200,
            headers={"Content-Type": "application/json"}
        )
    
    except Exception as e:
        logging.error(f"Error updating todo: {str(e)}")
        return func.HttpResponse(
            body=json.dumps({"error": "An error occurred while updating todo", "details": str(e)}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        )
    
####################
# Enrich a todo item
####################
@app.service_bus_topic_trigger(arg_name="message",
                              connection="SERVICE_BUS_CONNECTION_STRING",
                              topic_name=SERVICE_BUS_TOPIC_NAME,
                              subscription_name=SERVICE_BUS_SUBSCRIBER_NAME)
def enrich_todo_item(message: str):
    logging.info('Python Service Bus trigger function processed a message to enrich a todo.')
    try:
        record = json.loads(message)
        id = record.get('id')
        label = record.get('label')
        description = record.get('description')

        prompt = f"""
        INSTRUCTIONS:
        You task is generate very short motivational speech for ToDo item that use has created. You will be presented with label and description of the ToDo item. 
        You need to generate motivational speech that will encourage user to complete the task.
        You may use quotes, proverbs, or any other motivational content to generate the speech.
        Be friendly and encouraging in your speech.
        Be funny and cool.
        If user writes in English, you should respond in English. If user writes in Czech, you should respond in Czech.

        LABEL: {label}
        DESCRIPTION: {description}
        """
        messages = [{"role": "system", "content": prompt}]
        response = client.chat.completions.create(model=AZURE_OPENAI_DEPLOYMENT, messages=messages, max_tokens=200)
    
        record['ai_recommendation'] = response.choices[0].message.content

        db_item = db.query(TodoItemDB).filter(TodoItemDB.id == id).first()
        if db_item is None:
            return func.HttpResponse(
                body=json.dumps({"error": "Todo item not found"}),
                status_code=404,
                headers={"Content-Type": "application/json"}
            )
        
        for key, value in record.items():
            setattr(db_item, key, value)
        db.commit()
        db.refresh(db_item)

    except Exception as e:
        logging.error(f"Error enriching todo: {str(e)}")