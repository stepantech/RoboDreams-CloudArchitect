import os
from azure.servicebus import ServiceBusClient, ServiceBusMessage
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
import time
from dotenv import load_dotenv
import uuid

# Load environment variables
load_dotenv()

# Service Bus Fully Qualified Domain Name and Topic Name from environment variables
SB_FQDN = os.environ["SB_FQDN"]
TOPIC_NAME = os.environ["TOPIC_NAME"]
SB_SUBSCRIPTION_NAME = os.environ["SB_SUBSCRIPTION_NAME"]
BATCH_SIZE = int(os.environ["BATCH_SIZE"])
PROCESSING_TIME = int(os.environ["PROCESSING_TIME"])
STORAGE_ACCOUNT_URL = os.environ["STORAGE_ACCOUNT_URL"]  # Blob Storage account URL
CONTAINER_NAME = os.environ["CONTAINER_NAME"]

# Authenticate using the default Azure credential
credential = DefaultAzureCredential()

# Initialize Service Bus client
service_bus_client = ServiceBusClient(SB_FQDN, credential)
receiver = service_bus_client.get_subscription_receiver(topic_name=TOPIC_NAME, subscription_name=SB_SUBSCRIPTION_NAME)

# Initialize Blob Service client with AAD authentication
blob_service_client = BlobServiceClient(account_url=STORAGE_ACCOUNT_URL, credential=credential)
container_client = blob_service_client.get_container_client(CONTAINER_NAME)

# Read messages from the Service Bus topic forever
while True:
    # Receive a message from the Service Bus topic
    receiver.receive_messages(max_message_count=BATCH_SIZE, max_wait_time=5)
    for message in receiver:
        print(f"Processing message: {message}")

        # Simulate processing time
        time.sleep(PROCESSING_TIME)

        # Generate a GUID for the filename
        filename = f"{uuid.uuid4()}.json"

        # Convert message to JSON and upload to Blob Storage
        message_content = b"".join(message.body).decode('utf-8')
        blob_client = container_client.get_blob_client(blob=filename)
        blob_client.upload_blob(message_content, overwrite=True)

        # Complete the message so that it is removed from the Service Bus topic
        receiver.complete_message(message)


