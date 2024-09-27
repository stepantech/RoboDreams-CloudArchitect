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

def print_trace(trace, title, filename):
    # Create a table to store the trace
    duration = timedelta(0)
    trace_table = PrettyTable()
    trace_table.field_names = ["Time", "Source", "Duration", "Description"]
    for event in trace.events:
        trace_table.add_row([event.datetime, event.source, event.source_elapsed, event.description])
        if event.source_elapsed is not None:
            duration = duration + event.source_elapsed

    # Add title and duration to the table
    duration_ms = duration.total_seconds() * 1000
    trace_table.title = f"{title}, Duration: {duration_ms} ms"

    # Print table
    print(trace_table)

    # Store the table in a file
    with open(filename, 'w') as file:
        file.write(trace_table.get_string())

# Consistency level: LOCAL_ONE
statement = SimpleStatement(
    "INSERT INTO three_dc_three_replicas.mytable (id, value) VALUES (2, 'record A');",
    consistency_level=ConsistencyLevel.LOCAL_ONE
)
result = session.execute(statement, trace=True)
trace = result.get_query_trace()
print_trace(trace, "Consistency level: LOCAL_ONE", "WRITE_LOCAL_ONE.txt")


# Consistency level: LOCAL_QUORUM
statement_local_quorum = SimpleStatement(
    "INSERT INTO three_dc_three_replicas.mytable (id, value) VALUES (3, 'record B');",
    consistency_level=ConsistencyLevel.LOCAL_QUORUM
)
result = session.execute(statement_local_quorum, trace=True)
trace = result.get_query_trace()
print_trace(trace, "Consistency level: LOCAL_QUORUM", "WRITE_LOCAL_QUORUM.txt")

# Consistency level: EACH_QUORUM
statement_each_quorum = SimpleStatement(
    "INSERT INTO three_dc_three_replicas.mytable (id, value) VALUES (4, 'record C');",
    consistency_level=ConsistencyLevel.EACH_QUORUM
)
result = session.execute(statement_each_quorum, trace=True)
trace = result.get_query_trace()
print_trace(trace, "Consistency level: EACH_QUORUM", "WRITE_EACH_QUORUM.txt")

# Consistency level: ALL
statement_all = SimpleStatement(
    "INSERT INTO three_dc_three_replicas.mytable (id, value) VALUES (5, 'record D');",
    consistency_level=ConsistencyLevel.ALL
)
result = session.execute(statement_all, trace=True)
trace = result.get_query_trace()
print_trace(trace, "Consistency level: ALL", "WRITE_ALL.txt")