from pydantic import BaseModel, Field
from pydantic.error_wrappers import ValidationError
import azure.functions as func
import uuid
import logging
import json
import os
from azure.cosmos import CosmosClient
from azure.cosmos.exceptions import CosmosResourceNotFoundError, CosmosHttpResponseError
from azure.identity import DefaultAzureCredential



# Get Cosmos DB client
credential = DefaultAzureCredential()
cosmos_url = os.environ["CosmosDBConnection__accountEndpoint"]
logging.info(f"Trying to connect to Cosmos DB at {cosmos_url}")
client = CosmosClient(url=cosmos_url, credential=credential)
database = client.get_database_client("mydb")
container = database.get_container_client("books")

# Instantiate the Function App
app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

# ==================================================
# Function: Create a New Book
# Route: POST /books
# ==================================================
@app.route(route="books", methods=["POST"], auth_level=func.AuthLevel.FUNCTION)
@app.cosmos_db_output(
    arg_name="documents",
    connection='CosmosDBConnection',
    database_name='mydb',
    container_name='books',
    create_if_not_exists=False,
)
def createBook(req: func.HttpRequest, documents: func.Out[func.Document]) -> func.HttpResponse:
    """
Creates a new book entry in the database from the HTTP request data.

This function is triggered by an HTTP POST request. It expects a JSON payload
with the book's details, validates the data using the Book model, and then
saves the new book document to Cosmos DB. If the data is invalid or the request
cannot be processed, it returns an appropriate HTTP response.

Args:
    req (func.HttpRequest): The HTTP request object containing the payload.
    documents (func.Out[func.Document]): The Cosmos DB output binding used to save the new book document.

Returns:
    func.HttpResponse: An HTTP response object. Returns a 201 status code with the created book document
    if successful. Returns a 400 status code if the request data is invalid or not in JSON format.
    Returns a 500 status code if an unexpected error occurs.
    """
    logging.info(
        'Python HTTP trigger function processed a request to create a book.')

    try:
        # Parse and validate the request body using Pydantic
        book_data = req.get_json()
        book = Book(**book_data)

        # Convert the Pydantic model to a dict for Cosmos DB
        book_document = book.model_dump_json()

        # Set the document in the output binding to save to Cosmos DB
        documents.set(func.Document.from_json(book_document))

        # Return the created book document as JSON
        return func.HttpResponse(
            body=json.dumps({"message": "Book created successfully", "book": book_document}),
            status_code=201,
            headers={"Content-Type": "application/json"}
        )

    except ValidationError as e:
        return func.HttpResponse(
            body=json.dumps({"error": "Invalid data", "details": e.errors()}),
            status_code=400,
            headers={"Content-Type": "application/json"}
        )
    except ValueError:
        return func.HttpResponse(
            body=json.dumps({"error": "Invalid JSON in request body"}),
            status_code=400,
            headers={"Content-Type": "application/json"}
        )
    except Exception as e:
        logging.error(f"Error creating book: {str(e)}")
        return func.HttpResponse(
            body=json.dumps({"error": "An error occurred while creating the book", "details": str(e)}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        )

# ==================================================
# Function: Get one Book by ID
# Route: GET /books/{id}
# ==================================================
@app.route(route="books/{id}", methods=["GET"], auth_level=func.AuthLevel.FUNCTION)
@app.cosmos_db_input(arg_name="documents",
                     connection='CosmosDBConnection',
                     database_name='mydb',
                     container_name='books',
                     id="{id}",
                     partition_key="{id}",
                     )
def readBook(req: func.HttpRequest, documents: func.DocumentList) -> func.HttpResponse:
    """
    Retrieves a book document from Cosmos DB using the provided ID in the request route.

    This function is triggered by an HTTP GET request. It looks up a book document in Cosmos DB
    using the ID provided in the request route. If the book is found, it returns the book document
    as a JSON response. If no book is found with the given ID, it returns a 404 Not Found response.

    Args:
        req (func.HttpRequest): The HTTP request object, containing route parameters.
        documents (func.DocumentList): The Cosmos DB input binding used to retrieve the book document.

    Returns:
        func.HttpResponse: An HTTP response object. Returns a 200 status code with the book document
        as JSON if the book is found. Returns a 404 status code with a message indicating the book
        was not found if no document exists for the given ID.
    """
    id = req.route_params.get('id')
    logging.info(f"Getting book with id: {id}")

    # Check if the document exists
    if not documents:
        logging.info(f"No book found with id: {id}")
        return func.HttpResponse(
            body=json.dumps({"error": "Book not found", "id": id}),
            status_code=404,
            headers={"Content-Type": "application/json"}
        )

    # If the document exists, proceed to return it
    logging.info(f"Document: {json.dumps(documents[0].to_dict())}")
    return func.HttpResponse(
        body=json.dumps(documents[0].to_dict()),
        status_code=200,
        headers={"Content-Type": "application/json"}
    )

# ==================================================
# Function: Update one Book by ID
# Route: PUT /books/{id}
# ==================================================
@app.route(route="books/{id}", methods=["PUT"], auth_level=func.AuthLevel.FUNCTION)
def updateBook(req: func.HttpRequest) -> func.HttpResponse:
    """
    Updates an existing book document in Cosmos DB with the provided data.

    This function is triggered by an HTTP POST request to the specified route with a book ID.
    It attempts to retrieve the book document with the given ID from Cosmos DB. If the document
    is found, it updates the document with the data provided in the request body. If no document
    is found with the given ID, it returns a 404 Not Found response.

    Args:
        req (func.HttpRequest): The HTTP request object, containing the payload with update data and route parameters.
        documents (func.DocumentList): The Cosmos DB input binding used to retrieve and update the book document.

    Returns:
        func.HttpResponse: An HTTP response object. Returns a 200 status code with the updated book document
        as JSON if the update is successful. Returns a 404 status code with a message indicating the book
        was not found if no document exists for the given ID.
    """
    id = req.route_params.get('id')
    logging.info(f"Updating book with id: {id}")

    # Check body for update data according to schema
    try:
        update_data = req.get_json()
        update = UpdateBook(**update_data)
    except ValidationError as e:
        return func.HttpResponse(
            json.dumps({"error": "Invalid data", "details": e.errors()}),
            status_code=400,
            headers={"Content-Type": "application/json"}
        )
    except ValueError as e:
        return func.HttpResponse(
            json.dumps({"error": "Invalid JSON in request body"}),
            status_code=400,
            headers={"Content-Type": "application/json"}
        )
    
    # Retrieve the existing document
    try:
        existing_book = container.read_item(item=id, partition_key=id)
    except CosmosResourceNotFoundError:
        return func.HttpResponse(
            body=json.dumps({"error": "Book not found", "id": id}),
            status_code=404,
            headers={"Content-Type": "application/json"}
        )

    # Update the document with fields provided in the request
    for field, value in update_data.items():
        if field in existing_book and value is not None:
            existing_book[field] = value

    # Upsert the updated document
    container.upsert_item(existing_book)

    return func.HttpResponse(
        body=json.dumps({"message": "Book updated successfully", "id": id, "updatedFields": update_data}),
        status_code=200,
        headers={"Content-Type": "application/json"}
    )


# ==================================================
# Function: Delete one Book by ID
# Route: DELETE /books/{id}
# ==================================================
@app.route(route="books/{id}", methods=["DELETE"], auth_level=func.AuthLevel.FUNCTION)
def deleteBook(req: func.HttpRequest) -> func.HttpResponse:
    """
    Deletes a book document from Cosmos DB based on the provided ID in the request route.

    This function is invoked by an HTTP DELETE request. It aims to delete a specific book document
    from Cosmos DB using the ID specified in the request route. Upon successful deletion of the book,
    it returns a 204 No Content response. If the specified book cannot be found, it returns a 404 Not Found
    response to indicate the absence of the document.

    Parameters:
        req (func.HttpRequest): The HTTP request object, which includes route parameters.

    Returns:
        func.HttpResponse: The HTTP response object. It returns a 204 status code if the deletion is successful,
        indicating that the book has been deleted. If no book matches the given ID, it returns a 404 status code
        with a message stating that the book was not found. For any other errors, it returns a 500 status code.
    """
    id = req.route_params.get('id')
    logging.info(f"Attempting to delete book with id: {id}")

    try:
        container.delete_item(item=id, partition_key=id)
        return func.HttpResponse(
            status_code=204,
            headers={"Content-Type": "application/json"}
        )
    except CosmosResourceNotFoundError:
        return func.HttpResponse(
            body=json.dumps({"error": "Book not found", "id": id}),
            status_code=404,
            headers={"Content-Type": "application/json"}
        )
    except CosmosHttpResponseError as e:
        logging.error(f"Deletion failed for book with id: {id}, error: {str(e)}")
        return func.HttpResponse(
            body=json.dumps({"error": "Deletion failed", "details": str(e)}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        )
    
# ==================================================
# Function: Query Books
# Route: GET /books
# ==================================================
@app.route(route="books", methods=["GET"], auth_level=func.AuthLevel.FUNCTION)
def queryBooks(req: func.HttpRequest) -> func.HttpResponse:
    """
    Queries book documents in the Cosmos DB container and returns them as a JSON response.

    This function is triggered by an HTTP GET request to the specified route. It retrieves all book
    documents from the Cosmos DB container and returns them as a JSON response. If no documents are found,
    it returns an empty list. If an error occurs during the query, it returns a 500 Internal Server Error.

    Args:
        req (func.HttpRequest): The HTTP request object. The function expects the following query parameters:
            - title (str, optional): The title of the book to filter by.
            - author (str, optional): The author of the book to filter by.
            - isbn (str, optional): The ISBN of the book to filter by.
            - genre (str, optional): The genre of the book to filter by.
            - publishedDate (str, optional): The publication date of the book to filter by.

    Returns:
        func.HttpResponse: An HTTP response object. Returns a 200 status code with a JSON list of book documents
        if the query is successful. Returns a 500 status code with an error message if an error occurs.
    """
    # Get filter parameters
    title = req.params.get('title')
    author = req.params.get('author')
    isbn = req.params.get('isbn')
    genre = req.params.get('genre')
    publishedDate = req.params.get('publishedDate')

    # Prepare quire
    query_conditions = []

    if title:
        query_conditions.append(f"c.title = '{title}'")
    if author:
        query_conditions.append(f"c.author = '{author}'")
    if isbn:
        query_conditions.append(f"c.isbn = '{isbn}'")
    if genre:
        query_conditions.append(f"c.genre = '{genre}'")
    if publishedDate:
        query_conditions.append(f"c.publishedDate = '{publishedDate}'")

    query = "SELECT * FROM c"
    if query_conditions:
        query += " WHERE " + " AND ".join(query_conditions)

    logging.info(f"Querying books from Cosmos DB with filters: title={title}, author={author}, isbn={isbn}, genre={genre}, publishedDate={publishedDate}")

    try:
        # Query books
        books = list(container.query_items(query=query, enable_cross_partition_query=True))

        # Convert the list of documents to a list of dicts
        books_data = [book for book in books]

        return func.HttpResponse(
            body=json.dumps(books_data),
            status_code=200,
            headers={"Content-Type": "application/json"}
        )
    except Exception as e:
        logging.error(f"Error querying books: {str(e)}")
        return func.HttpResponse(
            body=json.dumps({"error": "An error occurred while querying books", "details": str(e)}),
            status_code=500,
            headers={"Content-Type": "application/json"}
        )