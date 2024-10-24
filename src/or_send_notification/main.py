import logging
import json
import time
import os
from flask import Flask, request, jsonify

app = Flask(__name__)
logging.basicConfig(level = logging.INFO)

@app.route('/notifyTripCreated', methods=['POST'])
def notify_user():
    request_data = request.json
    logging.info(f"Notifying user {request_data['userId']} that trip {request_data['tripRequestId']} has been created")
    
    return jsonify({"message": "Accepted"}), 202

@app.route('/notifyDriverAssigned', methods=['POST'])
def notify_driver():
    request_data = request.json
    logging.info(f"Notifying user {request_data['userId']} and driver {request_data['driverId']} that trip {request_data['tripRequestId']} is paired")
    
    return jsonify({"message": "Accepted"}), 202

@app.route('/healthz', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)
