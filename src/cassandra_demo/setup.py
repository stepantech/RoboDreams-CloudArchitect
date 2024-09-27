from cassandra.cluster import Cluster
from ssl import SSLContext, CERT_NONE, PROTOCOL_TLS
import ssl
from cassandra.auth import PlainTextAuthProvider
import os
from dotenv import load_dotenv
import logging
import json
from prettytable import PrettyTable

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

# Create keyspaces
print("Creating keyspaces...")
session.execute(f"""
CREATE KEYSPACE IF NOT EXISTS one_dc_two_replicas
WITH REPLICATION = {{
    'class': 'NetworkTopologyStrategy',
    '{CASSANDRA_DC1}': 2
}};
""")

session.execute(f"""
CREATE KEYSPACE IF NOT EXISTS one_dc_three_replicas
WITH REPLICATION = {{
    'class': 'NetworkTopologyStrategy',
    '{CASSANDRA_DC1}': 3
}};
""")

session.execute(f"""
CREATE KEYSPACE IF NOT EXISTS three_dc_two_replicas
WITH REPLICATION = {{
    'class': 'NetworkTopologyStrategy',
    '{CASSANDRA_DC1}': 2,
    '{CASSANDRA_DC2}': 2,
    '{CASSANDRA_DC3}': 2
}};
""")

session.execute(f"""
CREATE KEYSPACE IF NOT EXISTS three_dc_three_replicas
WITH REPLICATION = {{
    'class': 'NetworkTopologyStrategy',
    '{CASSANDRA_DC1}': 3,
    '{CASSANDRA_DC2}': 3,
    '{CASSANDRA_DC3}': 3
}};
""")

# Create tables
print("Creating tables...")
session.execute(f"""
CREATE TABLE IF NOT EXISTS one_dc_two_replicas.mytable (
    id int PRIMARY KEY,
    value TEXT
);
""")

session.execute(f"""
CREATE TABLE IF NOT EXISTS one_dc_three_replicas.mytable (
    id int PRIMARY KEY,
    value TEXT
);
""")

session.execute(f"""
CREATE TABLE IF NOT EXISTS three_dc_two_replicas.mytable (
    id int PRIMARY KEY,
    value TEXT
);
""")

session.execute(f"""
CREATE TABLE IF NOT EXISTS three_dc_three_replicas.mytable (
    id int PRIMARY KEY,
    value TEXT
);
""")

# Insert data
print("Inserting data...")
session.execute("INSERT INTO one_dc_two_replicas.mytable (id, value) VALUES (1, 'record A');")
session.execute("INSERT INTO one_dc_three_replicas.mytable (id, value) VALUES (1, 'record A');")
session.execute("INSERT INTO three_dc_two_replicas.mytable (id, value) VALUES (1, 'record A');")
session.execute("INSERT INTO three_dc_three_replicas.mytable (id, value) VALUES (1, 'record A');")

# Query data
print("Querying data...\n\n")

def PrintTable(rows, title):
    t = PrettyTable(['id', 'value'])
    t.title = title
    for r in rows:
        t.add_row([r.id, r.value])
    print (t)

rows = session.execute("SELECT * FROM one_dc_two_replicas.mytable;")
PrintTable(rows, "one_dc_two_replicas.mytable")
print()

rows = session.execute("SELECT * FROM one_dc_three_replicas.mytable;")
PrintTable(rows, "one_dc_three_replicas.mytable")
print()

rows = session.execute("SELECT * FROM three_dc_two_replicas.mytable;")
PrintTable(rows, "three_dc_two_replicas.mytable")
print()

rows = session.execute("SELECT * FROM three_dc_three_replicas.mytable;")
PrintTable(rows, "three_dc_three_replicas.mytable")
print()
