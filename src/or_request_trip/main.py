import logging
import json
import os
import uuid
import asyncio
import threading
from faker import Faker
from flask import Flask, request, jsonify
from dotenv import load_dotenv
import requests

# Load environment variables from .env file
load_dotenv()
NOTIFICATION_BASE_URL = os.getenv("NOTIFICATION_BASE_URL")
ASSIGN_DRIVER_BASE_URL = os.getenv("ASSIGN_DRIVER_BASE_URL")

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

fake = Faker()

async def orchestrate(message):
    logging.info(f"Orchestrating with message: {message}")

    # Notify user
    logging.info(f"Notifying about trip creation")
    notification_data = {
        "tripRequestId": message["tripRequestId"],
        "userId": message["userId"]
    }
    response = requests.post(f"{NOTIFICATION_BASE_URL}/notifyTripCreated", json=notification_data)
    logging.info(f"Notification response: {response.json()}")

    # Assign driver
    logging.info(f"Assigning driver for trip")
    trip_data = {
        "tripRequestId": message["tripRequestId"],
        "source": message["source"],
        "destination": message["destination"],
        "userId": message["userId"]
    }
    response = requests.post(f"{ASSIGN_DRIVER_BASE_URL}/assignDriver", json=trip_data)
    logging.info(f"Driver assignment response: {response.json()}")
    driver_id = response.json()["driverId"]

    # Notify about driver assigned event
    logging.info(f"Notifying about driver assignment")
    notification_data = {
        "tripRequestId": message["tripRequestId"],
        "userId": message["userId"],
        "driverId": driver_id
    }
    response = requests.post(f"{NOTIFICATION_BASE_URL}/notifyDriverAssigned", json=notification_data)
    logging.info(f"Notification response: {response.json()}")

def run_event_loop(loop):
    asyncio.set_event_loop(loop)
    loop.run_forever()

# Create a new event loop and run it in a background thread
event_loop = asyncio.new_event_loop()
threading.Thread(target=run_event_loop, args=(event_loop,), daemon=True).start()

@app.route('/', methods=['POST'])
def send_message():
    request_data = request.json
    try:
        user_id = request_data['userId']
    except KeyError:
        return jsonify({"message": "Missing required field 'userId'"}), 400
    
    message = {
        "tripRequestId": str(uuid.uuid4()),
        "source": fake.city(),
        "destination": fake.city(),
        "userId": user_id,
    }

    # Run orchestrate function in the background
    event_loop.call_soon_threadsafe(asyncio.create_task, orchestrate(message))
    
    return jsonify({"message": "Accepted", "data": message}), 202

@app.route('/healthz', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)