from cloudevents.sdk.event import v1
from dapr.ext.grpc import App
from dapr.clients import DaprClient
import logging
import json
import time
import os
from faker import Faker

app = App()
dapr = DaprClient()
fake = Faker()

logging.basicConfig(level = logging.INFO)

PUBSUB_NAME = os.environ.get('PUBSUB_NAME')
TRIP_CREATED_TOPIC_NAME = os.environ.get('TRIP_CREATED_TOPIC_NAME')
DRIVER_ASSIGNED_TOPIC_NAME = os.environ.get('DRIVER_ASSIGNED_TOPIC_NAME')

@app.subscribe(pubsub_name=PUBSUB_NAME, topic=TRIP_CREATED_TOPIC_NAME)
def process_event(event: v1.Event) -> None:
    data = json.loads(event.Data())
    logging.info(f"Assign driver service received message: {str(data)}")
    time.sleep(1)
    driverId = fake.user_name()
    logging.info(f"Driver {driverId} assigned for trip {data['tripRequestId']}")

    message = {
        "tripRequestId": data["tripRequestId"],
        "source": data["source"],
        "destination": data["destination"],
        "userId": data["userId"],
        "driverId": driverId,
    }

    try:
        dapr.publish_event(
            pubsub_name=PUBSUB_NAME,
            topic_name=DRIVER_ASSIGNED_TOPIC_NAME,
            data=json.dumps(message),
            data_content_type='application/json',
        )
    except Exception as err:
        logging.error(f'Error publishing event: {err}')
    

if __name__ == '__main__':
    app.run(5000)


