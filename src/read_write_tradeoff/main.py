import psycopg2
from dotenv import load_dotenv
import os
from faker import Faker
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient
from azure.identity import DefaultAzureCredential
from db_setup import setup_db 
from blob_utils import blob_write, blob_query
from db_utils import insert_data_in_batches, write_readoptimized, write_writeoptimized, query_readoptimized, query_writeoptimized

# Load environment variables
load_dotenv()

# Get environment variables
STORAGE_ACCOUNT_URL = os.environ["STORAGE_ACCOUNT_URL"]
CONTAINER_NAME = os.environ["CONTAINER_NAME"]
ROWS_COUNT = int(os.getenv("ROWS_COUNT"))
PGHOST = os.getenv("PGHOST")
PGPASSWORD = os.getenv("PGPASSWORD")

# Authenticate storage using the default Azure credential
credential = DefaultAzureCredential()
blob_service_client = BlobServiceClient(account_url=STORAGE_ACCOUNT_URL, credential=credential)
container_client = blob_service_client.get_container_client(CONTAINER_NAME)

# Connect to the database
conn_string = f"host={PGHOST} dbname=mydb user=psqladmin password={PGPASSWORD} sslmode=require"
conn = psycopg2.connect(conn_string)
cursor = conn.cursor()

# Prepare the database
setup_db(cursor, conn)

# Generate data
fake = Faker()
data = []
for _ in range(ROWS_COUNT):
    row = [fake.text(max_nb_chars=200) for _ in range(8)]  # Generate text for 8 columns
    data.append(row)

# Test the write and query performance
write_raw_duration = blob_write(container_client, data)
write_readoptimized_duration = write_readoptimized(cursor, conn, data)
write_writeoptimized_duration = write_writeoptimized(cursor, conn, data)
query_raw_duration = blob_query(container_client)
query_readoptimized_duration = query_readoptimized(cursor)
query_writeoptimized_duration = query_writeoptimized(cursor)


# Print the results
results = f"""
Results:
--------
WRITE to Raw storage: {write_raw_duration:.2f} seconds
WRITE to Write-optimized table: {write_writeoptimized_duration:.2f} seconds
WRITE to Read-optimized table: {write_readoptimized_duration:.2f} seconds
QUERY Raw storage: {query_raw_duration:.2f} seconds
QUERY Write-optimized table: {query_writeoptimized_duration:.2f} seconds
QUERY Read-optimized table: {query_readoptimized_duration:.2f} seconds
"""

print(results)

# Write results to a file and upload to blob storage
with open('results.txt', 'w') as file:
    file.write(results)

blob_client = container_client.get_blob_client("results.txt")
with open("results.txt", "rb") as data:
    blob_client.upload_blob(data, overwrite=True)

