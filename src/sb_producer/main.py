import os
from azure.servicebus import ServiceBusClient, ServiceBusMessage
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv
from faker import Faker
from faker.providers import profile, phone_number, isbn
import json
import time

# Load environment variables
load_dotenv()

# Service Bus Fully Qualified Domain Name and Topic Name from environment variables
SB_FQDN = os.environ["SB_FQDN"]
TOPIC_NAME = os.environ["TOPIC_NAME"]
RATE = int(os.environ["RATE"])

# Authenticate using the default Azure credential
credential = DefaultAzureCredential()
client = ServiceBusClient(SB_FQDN, credential)
sender = client.get_topic_sender(topic_name=TOPIC_NAME)

# Initialize Faker and add providers
fake = Faker()
fake.add_provider(isbn)
fake.add_provider(profile)
fake.add_provider(phone_number)

# Send messages to the Service Bus topic forever
while True:
    # Generate a fake profile with specific fields
    message = fake.profile(fields={"username", "mail"})
    message["isbn"] = fake.isbn13()
    message["title"] = fake.sentence(nb_words=6, variable_nb_words=True)
    message["author"] = fake.name()
    message["count"] = fake.random_int(min=1, max=10)
    message["time_generated"] = time.strftime("%Y-%m-%d %H:%M:%S")
    # Send a message to the Service Bus topic
    sender.send_messages(ServiceBusMessage(json.dumps(message)))
    print(f"Sent message: {message}")
    # Sleep for the calculated time
    time.sleep(60 / RATE)


