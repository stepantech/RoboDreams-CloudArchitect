resource "azurerm_api_management_api_operation" "update_book" {
  operation_id        = "updateBook"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "updateBook"
  method              = "PUT"
  url_template        = "/books/{id}"
  description         = <<EOF
    Updates an existing book document in Cosmos DB with the provided data.

    This function is triggered by an HTTP POST request to the specified route with a book ID.
    It attempts to retrieve the book document with the given ID from Cosmos DB. If the document
    is found, it updates the document with the data provided in the request body. If no document
    is found with the given ID, it returns a 404 Not Found response.
EOF

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

  request {
    description = <<EOF
Represents a book with properties to store in a database.

Attributes:
    title (str, optional): The title of the book.
    author (str, optional): The author of the book.
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
  "title": "Changed Book Title"
}
EOF
      }
    }
  }

  response {
    status_code = 200
    description = "The book was successfully updated."

    representation {
      content_type = "application/json"

      example {
        name  = "book"
        value = <<EOF
{
  "message": "Book updated successfully",
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "updatedFields": {
    "title": "Chenged Book Title",
  }
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
    status_code = 404
    description = "The book with the specified ID was not found."
  }

  response {
    status_code = 500
    description = "An error occurred while processing the request."
  }
}

resource "azurerm_api_management_api_operation_policy" "update_book" {
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.update_book.operation_id
  xml_content         = local.books_policy

  depends_on = [azurerm_api_management_backend.books]
}
