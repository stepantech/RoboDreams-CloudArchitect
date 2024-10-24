import logging
from flask import Flask, request, jsonify
from faker import Faker

app = Flask(__name__)
logging.basicConfig(level = logging.INFO)

fake = Faker()

@app.route('/assignDriver', methods=['POST'])
def notify_user():
    request_data = request.json
    output = {
        "tripRequestId": request_data["tripRequestId"],
        "source": request_data["source"],
        "destination": request_data["destination"],
        "userId": request_data["userId"],
        "driverId": fake.user_name(),
    }
    
    return jsonify(output), 200

@app.route('/healthz', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)
