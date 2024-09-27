from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from cassandra.query import SimpleStatement
from cassandra import ConsistencyLevel
from ssl import SSLContext, CERT_NONE, PROTOCOL_TLS
import os
from dotenv import load_dotenv
import logging
import json
from prettytable import PrettyTable
from datetime import timedelta

# Load environment variables
load_dotenv()

# Authenticate and connect to the Cassandra cluster
CASSANDRA_USERNAME = os.environ["CASSANDRA_USERNAME"]
CASSANDRA_PASSWORD = os.environ["CASSANDRA_PASSWORD"]
CASSANDRA_IPS = os.environ["CASSANDRA_IPS"]
CASSANDRA_DC1 = os.environ["CASSANDRA_DC1"]
CASSANDRA_DC2 = os.environ["CASSANDRA_DC2"]
CASSANDRA_DC3 = os.environ["CASSANDRA_DC3"]

# Logging configuration
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# Create SSL context
ssl_context = SSLContext(PROTOCOL_TLS)
ssl_context.verify_mode = CERT_NONE
ssl_context.check_hostname = False

# Connect to the Cassandra cluster
auth_provider = PlainTextAuthProvider(username=CASSANDRA_USERNAME, password=CASSANDRA_PASSWORD)
cluster = Cluster(json.loads(CASSANDRA_IPS), auth_provider=auth_provider, ssl_context=ssl_context, protocol_version=4)
session = cluster.connect()

# Truncate tables
print("Truncating tables...")
session.execute("TRUNCATE one_dc_two_replicas.mytable;")
session.execute("TRUNCATE one_dc_three_replicas.mytable;")
session.execute("TRUNCATE three_dc_two_replicas.mytable;")
session.execute("TRUNCATE three_dc_three_replicas.mytable;")