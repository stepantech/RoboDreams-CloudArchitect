import os
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

STORAGE_ACCOUNT_URL = os.environ["STORAGE_ACCOUNT_URL"]  # Blob Storage account URL
CONTAINER_NAME = os.environ["CONTAINER_NAME"]

# Authenticate using the default Azure credential
credential = DefaultAzureCredential()

# Initialize Blob Service client with AAD authentication
blob_service_client = BlobServiceClient(account_url=STORAGE_ACCOUNT_URL, credential=credential)
container_client = blob_service_client.get_container_client(CONTAINER_NAME)

def upload_files_to_blob(folder_path):
    # List all files in the current directory
    for file_name in os.listdir(folder_path):
        # Check if it's a file, has a .txt extension, and is not requirements.txt
        if os.path.isfile(os.path.join(folder_path, file_name)) and file_name.endswith('.txt') and file_name != "requirements.txt":
            # Generate the full file path
            file_path = os.path.join(folder_path, file_name)
            
            # Create a blob client using the local file name as the name for the blob
            blob_client = container_client.get_blob_client(blob=file_name)
            
            print(f"Uploading {file_name} to blob storage...")
            
            # Upload the file
            with open(file_path, "rb") as data:
                blob_client.upload_blob(data, overwrite=True)
            
            print(f"{file_name} uploaded successfully.")

# Upload all .txt files from the current folder
current_folder_path = os.getcwd()  # Get the current working directory
upload_files_to_blob(current_folder_path)
