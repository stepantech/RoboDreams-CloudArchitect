resource "azurerm_api_management_api_operation" "read_book" {
  operation_id        = "readBook"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "readBook"
  method              = "GET"
  url_template        = "/books/{id}"
  description         = <<EOF
    Retrieves a book document from Cosmos DB using the provided ID in the request route.

    This function is triggered by an HTTP GET request. It looks up a book document in Cosmos DB
    using the ID provided in the request route. If the book is found, it returns the book document
    as a JSON response. If no book is found with the given ID, it returns a 404 Not Found response.
EOF


  request {
    description = <<EOF
id in path (str): The unique identifier of the book to retrieve.
EOF
  }

  template_parameter {
    name        = "id"
    type        = "string"
    required    = true
    description = "The unique identifier of the book to retrieve."

    example {
      name  = "id"
      value = "123e4567-e89b-12d3-a456-426614174000"
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
    status_code = 404
    description = "Book not found"
  }
}

resource "azurerm_api_management_api_operation_policy" "read_book" {
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.read_book.operation_id
  xml_content         = local.books_policy

  depends_on = [azurerm_api_management_backend.books]
}
