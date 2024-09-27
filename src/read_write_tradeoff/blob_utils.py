import time
import nltk
from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize
import io
import pandas as pd

def blob_write(container_client, data):
    print(f"Writing data to CSV blob...")
    blob_client = container_client.get_blob_client("mydata.csv")

    start = time.time()
    blob_client.create_append_blob()

    for i in range(0, len(data), 1000):
        batch = data[i:i+1000]
        csv_data = '\n'.join([','.join(f'"{str(item).replace("\"", "\"\"").replace("\n", "\\n")}"' for item in row) for row in batch]) + '\n'
        blob_client.append_block(csv_data)
    
    duration = time.time() - start
    print(f"... Finished in {duration:.2f} seconds")
    return duration

def blob_query(container_client):
    print("Query data from raw storage...")
    blob_client = container_client.get_blob_client("mydata.csv")
    nltk.download('punkt')
    stemmer = PorterStemmer()

    start = time.time()

    with io.BytesIO() as blob_io:
        blob_client.download_blob().download_to_stream(blob_io)
        blob_io.seek(0)  # Go to the start of the stream
        column_names = ['col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7', 'col8']
        df = pd.read_csv(blob_io, header=None, names=column_names)

    # Function to preprocess text: tokenize and stem
    def preprocess_text(text):
        tokens = word_tokenize(text.lower())  # Tokenize and convert to lower case
        stemmed_tokens = [stemmer.stem(token) for token in tokens]  # Stem tokens
        return " ".join(stemmed_tokens)

    # Define your search terms and preprocess them
    search_terms = {
        'col1': 'friend',
        'col2': 'cat',
        'col3': 'dog',
        'col4': 'tree',
        'col5': 'train',
        'col6': 'orange'
    }
    stemmed_search_terms = {column: stemmer.stem(term) for column, term in search_terms.items()}

    # Preprocess text in each column
    for column in search_terms.keys():
        df[column] = df[column].astype(str).apply(preprocess_text)

    # Filter rows based on stemmed search terms
    mask = df.apply(lambda row: any(stemmer.stem(row[column]).find(stemmed_term) != -1 if row[column] is not None else False for column, stemmed_term in stemmed_search_terms.items()), axis=1)
    filtered_df = df[mask]

    # Count the rows that match the conditions
    count_matching_rows = len(filtered_df)

    duration = time.time() - start
    print(f"... Finished in {duration:.2f} seconds")
    return duration