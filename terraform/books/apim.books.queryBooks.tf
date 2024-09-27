resource "azurerm_api_management_api_operation" "query_books" {
  operation_id        = "queryBooks"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "queryBooks"
  method              = "GET"
  url_template        = "/books"
  description         = <<EOF
Queries book documents in the Cosmos DB container and returns them as a JSON response.

This function is triggered by an HTTP GET request to the specified route. It retrieves all book
documents from the Cosmos DB container and returns them as a JSON response. If no documents are found,
it returns an empty list. If an error occurs during the query, it returns a 500 Internal Server Error.
EOF


  request {
    description = <<EOF
Args:
    req (func.HttpRequest): The HTTP request object. The function expects the following query parameters:
        - title (str, optional): The title of the book to filter by.
        - author (str, optional): The author of the book to filter by.
        - isbn (str, optional): The ISBN of the book to filter by.
        - genre (str, optional): The genre of the book to filter by.
        - publishedDate (str, optional): The publication date of the book to filter by.
EOF

    query_parameter {
      name        = "title"
      type        = "string"
      required    = false
      description = "The title of the book to filter by."

      example {
        name  = "title"
        value = "Example Book Title"
      }
    }

    query_parameter {
      name        = "author"
      type        = "string"
      required    = false
      description = "The author of the book to filter by."

      example {
        name  = "author"
        value = "John Doe"
      }
    }

    query_parameter {
      name        = "isbn"
      type        = "string"
      required    = false
      description = "The ISBN of the book to filter by."

      example {
        name  = "isbn"
        value = "978-3-16-148410-0"
      }
    }

    query_parameter {
      name        = "genre"
      type        = "string"
      required    = false
      description = "The genre of the book to filter by."

      example {
        name  = "genre"
        value = "Fiction"
      }
    }

    query_parameter {
      name        = "publishedDate"
      type        = "string"
      required    = false
      description = "The publication date of the book to filter by."

      example {
        name  = "publishedDate"
        value = "2023-10-01"
      }
    }
  }

  response {
    status_code = 200
    description = "The book documents were successfully retrieved."

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
[
  {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "title": "Example Book Title",
    "author": "John Doe",
    "isbn": "978-3-16-148410-0",
    "publishedDate": "2023-10-01",
    "genre": "Fiction"
  },
  {
    "id": "123e4567-e89b-12d3-a456-426614174001",
    "title": "Another Example Book Title",
    "author": "Jane Smith",
    "isbn": "978-3-16-148410-1",
    "publishedDate": "2023-10-02",
    "genre": "Non-Fiction"
  }
]
EOF
      }
    }
  }

  response {
    status_code = 500
    description = "An error occurred while processing the request."
  }
}

resource "azurerm_api_management_api_operation_policy" "query_books" {
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.query_books.operation_id
  xml_content         = local.books_policy

  depends_on = [azurerm_api_management_backend.books]
}
