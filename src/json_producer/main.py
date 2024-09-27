import os
import json
import time
from dotenv import load_dotenv
from faker import Faker
from faker.providers import profile, phone_number, isbn
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient
from azure.identity import DefaultAzureCredential
import uuid

# Load environment variables
load_dotenv()

# Azure Blob Storage variables from environment variables
STORAGE_ACCOUNT_URL = os.environ["STORAGE_ACCOUNT_URL"]
CONTAINER_NAME = os.environ["CONTAINER_NAME"]
COUNT = int(os.environ["COUNT"])

# Authenticate using the default Azure credential
credential = DefaultAzureCredential()
blob_service_client = BlobServiceClient(account_url=STORAGE_ACCOUNT_URL, credential=credential)
container_client = blob_service_client.get_container_client(CONTAINER_NAME)

# Initialize Faker and add providers
fake = Faker()
fake.add_provider(isbn)
fake.add_provider(profile)
fake.add_provider(phone_number)

# Store messages as JSON files in the Azure Blob Storage container
for i in range(COUNT):
    # Generate a fake profile with specific fields
    record = fake.profile(fields={"username", "mail"})
    record["isbn"] = fake.isbn13()
    record["title"] = fake.sentence(nb_words=6, variable_nb_words=True)
    record["author"] = fake.name()
    record["count"] = fake.random_int(min=1, max=10)
    record["time_generated"] = time.strftime("%Y-%m-%d %H:%M:%S")
    
    # Convert the message to JSON
    record_json = json.dumps(record)
    
    # Create a unique blob name
    blob_name = f"myjsons/{uuid.uuid4()}.json"
    blob_client = container_client.get_blob_client(blob_name)
    
    # Upload the JSON data as a blob
    blob_client.upload_blob(record_json)
    print(f"Uploaded blob: {blob_name}")

