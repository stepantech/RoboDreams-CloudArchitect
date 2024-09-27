resource "azurerm_api_management_api_operation" "create_book" {
  operation_id        = "createBook"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "createBook"
  method              = "POST"
  url_template        = "/books"
  description         = <<EOF
Creates a new book entry in the database from the HTTP request data.

This function is triggered by an HTTP POST request. It expects a JSON payload
with the book's details, validates the data using the Book model, and then
saves the new book document to Cosmos DB. If the data is invalid or the request
cannot be processed, it returns an appropriate HTTP response.
EOF

  request {
    description = <<EOF
Represents a book with properties to store in a database.

Attributes:
    id (str): Unique identifier for the book, automatically generated.
    title (str): The title of the book.
    author (str): The author of the book.
    isbn (str, optional): The International Standard Book Number of the book. Defaults to None.
    publishedDate (str, optional): The publication date of the book. Defaults to None.
    genre (str, optional): The genre of the book. Defaults to None.
EOF

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
{
  "title": "Example Book Title",
  "author": "John Doe",
  "isbn": "978-3-16-148410-0",
  "publishedDate": "2023-10-01",
  "genre": "Fiction"
}
EOF
      }
    }
  }

  response {
    status_code = 201
    description = "The book was successfully created."

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "title": "Example Book Title",
  "author": "John Doe",
  "isbn": "978-3-16-148410-0",
  "publishedDate": "2023-10-01",
  "genre": "Fiction"
}
EOF
      }
    }
  }

  response {
    status_code = 400
    description = "The request was invalid, JSON object with book attributes was not provided or is not valid."
  }

  response {
    status_code = 500
    description = "An error occurred while processing the request."
  }
}

resource "azurerm_api_management_api_operation_policy" "create_book" {
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.create_book.operation_id
  xml_content         = local.books_policy

  depends_on = [azurerm_api_management_backend.books]
}
