import logging
import json
from dapr.clients import DaprClient
import os
import uuid
from faker import Faker
from flask import Flask, request, jsonify

app = Flask(__name__)
logging.basicConfig(level = logging.INFO)

PUBSUB_NAME = os.environ.get('PUBSUB_NAME')
TRIP_CREATED_TOPIC_NAME = os.environ.get('TRIP_CREATED_TOPIC_NAME')

dapr = DaprClient()
fake = Faker()

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

    try:
        dapr.publish_event(
            pubsub_name=PUBSUB_NAME,
            topic_name=TRIP_CREATED_TOPIC_NAME,
            data=json.dumps(message),
            data_content_type='application/json',
        )
    except Exception as err:
        logging.error(f'Error publishing event: {err}')
        return jsonify({"message": "Error publishing event"}), 500
    
    return jsonify({"message": "Event published", "data": message}), 200

@app.route('/healthz', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)

