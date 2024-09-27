import os
import time
import requests
import json
from dotenv import load_dotenv
import threading

# Load environment variables
load_dotenv()

# Extract endpoints and wait time from environment variables
endpoints = json.loads(os.getenv("ENDPOINTS", "[]"))
wait_time = int(os.getenv("WAIT_TIME", "1"))

def make_requests(endpoint):
	while True:
		try:
			response = requests.get(endpoint)
			print(f"Request to {endpoint} returned {response.status_code}")
		except Exception as e:
			print(f"Error making request to {endpoint}: {e}")
		time.sleep(wait_time)

if __name__ == "__main__":
	for endpoint in endpoints:
		thread = threading.Thread(target=make_requests, args=(endpoint,))
		thread.start()