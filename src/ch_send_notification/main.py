from cloudevents.sdk.event import v1
from dapr.ext.grpc import App
import logging
import json
import time
import os

app = App()

logging.basicConfig(level = logging.INFO)

PUBSUB_NAME = os.environ.get('PUBSUB_NAME')
TRIP_CREATED_TOPIC_NAME = os.environ.get('TRIP_CREATED_TOPIC_NAME')
DRIVER_ASSIGNED_TOPIC_NAME = os.environ.get('DRIVER_ASSIGNED_TOPIC_NAME')

@app.subscribe(pubsub_name=PUBSUB_NAME, topic=TRIP_CREATED_TOPIC_NAME)
def process_trip_created_event(event: v1.Event) -> None:
    data = json.loads(event.Data())
    logging.info(f"Notifying user {data['userId']} that trip {data['tripRequestId']} has been created")

@app.subscribe(pubsub_name=PUBSUB_NAME, topic=DRIVER_ASSIGNED_TOPIC_NAME)
def process_driver_assigned_event(event: v1.Event) -> None:
    data = json.loads(event.Data())
    logging.info(f"Notifying user {data['userId']} and driver {data['driverId']} that trip {data['tripRequestId']} is paired")

if __name__ == '__main__':
    app.run(5000)


