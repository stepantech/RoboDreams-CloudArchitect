# Cassandra
In this demo we have deployed managed Cassandra in Azure in 3 different regions with 3 instances in each region. Let's see in portal.

In Container Apps there is container running with few testing Python scripts. Go into console of this container.

First run `python setup.py` which will create keyspace and few tables with different replication factors. See code with CQL commands and discuss various settings.

Next we will test performance in extreme scenario using 3 replicas in 3 regions strategy from very weak consistency (ONE) all the way to very strong (ALL) and measure write and read speed.

Let's run write test using various consistency levels and get table with results by running `python write_speed.py`.

Now let's run read test using various consistency levels and get table with results by running `python read_speed.py`.

Resulting files can be uploaded to Azure Storage Account using `python upload.py`.

We will do this live, but you can see my previous results in cassandra_results folder.