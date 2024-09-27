import time

# Function to insert data in batches
def insert_data_in_batches(cursor, conn, table_name, data, batch_size=1000):
    print(f"Inserting data to {table_name}...")
    for i in range(0, len(data), batch_size):
        batch = data[i:i+batch_size]
        values_placeholder = ', '.join(['%s' for _ in range(8)])  # Placeholder for column values
        args_str = ','.join(cursor.mogrify(f"({values_placeholder})", row).decode('utf-8') for row in batch)
        cursor.execute(f"INSERT INTO {table_name} (col1, col2, col3, col4, col5, col6, col7, col8) VALUES {args_str};")
        print(f"... Inserted {min(i + batch_size, len(data))} rows")
    conn.commit()

def write_readoptimized(cursor, conn, data):
    start = time.time()
    insert_data_in_batches(cursor, conn, "readoptimized", data)
    duration = time.time() - start
    print(f"... Finished in {duration:.2f} seconds")
    return duration

def write_writeoptimized(cursor, conn, data):
    start = time.time()
    insert_data_in_batches(cursor, conn, "writeoptimized", data)
    duration = time.time() - start
    print(f"... Finished in {duration:.2f} seconds")
    return duration

def query_readoptimized(cursor):
    print("Quering readoptimized...")
    start = time.time()
    cursor.execute(f"""
        SELECT count(*)
        FROM readoptimized
        WHERE col1_tsv @@ to_tsquery('friend')
            OR col2_tsv @@ to_tsquery('cat')
            OR col3_tsv @@ to_tsquery('dog')
            OR col4_tsv @@ to_tsquery('tree')
            OR col5_tsv @@ to_tsquery('train')
            OR col6_tsv @@ to_tsquery('orange');
    """)

    duration = time.time() - start
    print(f"... Finished in {duration:.2f} seconds")
    return duration

def query_writeoptimized(cursor):
    print("Quering writeoptimized...")
    start = time.time()
    cursor.execute(f"""
        SELECT count(*)
        FROM writeoptimized
        WHERE to_tsvector(col1) @@ to_tsquery('friend')
            OR to_tsvector(col2) @@ to_tsquery('cat')
            OR to_tsvector(col3) @@ to_tsquery('dog')
            OR to_tsvector(col4) @@ to_tsquery('tree')
            OR to_tsvector(col5) @@ to_tsquery('train')
            OR to_tsvector(col6) @@ to_tsquery('orange');
    """)

    duration = time.time() - start
    print(f"... Finished in {duration:.2f} seconds")
    return duration