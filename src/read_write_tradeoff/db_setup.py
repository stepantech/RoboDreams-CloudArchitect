def setup_db(cursor, conn):
    # Drop previous table of same name if one exists
    print("Dropping table if exists...")
    cursor.execute("DROP TABLE IF EXISTS readoptimized;")
    cursor.execute("DROP TABLE IF EXISTS writeoptimized;")

    # Execute the create table statements
    print("Creating tables and indexes...")
    cursor.execute("""
    CREATE TABLE writeoptimized (
        id SERIAL PRIMARY KEY,
        col1 TEXT,
        col2 TEXT,
        col3 TEXT,
        col4 TEXT,
        col5 TEXT,
        col6 TEXT,
        col7 TEXT,
        col8 TEXT
    );
    """)

    cursor.execute("""
    CREATE TABLE readoptimized (
        id SERIAL PRIMARY KEY,
        col1 TEXT,
        col2 TEXT,
        col3 TEXT,
        col4 TEXT,
        col5 TEXT,
        col6 TEXT,
        col7 TEXT,
        col8 TEXT,
        col1_tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', col1)) STORED,
        col2_tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', col2)) STORED,
        col3_tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', col3)) STORED,
        col4_tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', col4)) STORED,
        col5_tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', col5)) STORED,
        col6_tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', col6)) STORED,
        col7_tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', col7)) STORED,
        col8_tsv tsvector GENERATED ALWAYS AS (to_tsvector('english', col8)) STORED
    );
    """
    )

    # Generate SQL statements to create an index on each column
    index_statements = [
        "CREATE INDEX readoptimized_col1_tsv_gin ON readoptimized USING GIN(col1_tsv);",
        "CREATE INDEX readoptimized_col2_tsv_gin ON readoptimized USING GIN(col2_tsv);",
        "CREATE INDEX readoptimized_col3_tsv_gin ON readoptimized USING GIN(col3_tsv);",
        "CREATE INDEX readoptimized_col4_tsv_gin ON readoptimized USING GIN(col4_tsv);",
        "CREATE INDEX readoptimized_col5_tsv_gin ON readoptimized USING GIN(col5_tsv);",
        "CREATE INDEX readoptimized_col6_tsv_gin ON readoptimized USING GIN(col6_tsv);",
        "CREATE INDEX readoptimized_col7_tsv_gin ON readoptimized USING GIN(col7_tsv);",
        "CREATE INDEX readoptimized_col8_tsv_gin ON readoptimized USING GIN(col8_tsv);"
    ]

    # Execute each index creation statement
    for statement in index_statements:
        cursor.execute(statement)

    # Commit the transaction
    conn.commit()
