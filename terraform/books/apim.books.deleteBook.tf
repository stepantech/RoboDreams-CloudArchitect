resource "azurerm_api_management_api_operation" "delete_book" {
  operation_id        = "deleteBook"
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "deleteBook"
  method              = "DELETE"
  url_template        = "/books/{id}"
  description         = <<EOF
Deletes a book document from Cosmos DB based on the provided ID in the request route.

This function is invoked by an HTTP DELETE request. It aims to delete a specific book document
from Cosmos DB using the ID specified in the request route. Upon successful deletion of the book,
it returns a 204 No Content response. If the specified book cannot be found, it returns a 404 Not Found
response to indicate the absence of the document.
EOF

  template_parameter {
    name        = "id"
    type        = "string"
    required    = true
    description = "The unique identifier of the book to delete."

    example {
      name  = "id"
      value = "123e4567-e89b-12d3-a456-426614174000"
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
    status_code = 204
    description = "The book was successfully deleted."
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

resource "azurerm_api_management_api_operation_policy" "delete_book" {
  api_name            = azurerm_api_management_api.books.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.delete_book.operation_id
  xml_content         = local.books_policy

  depends_on = [azurerm_api_management_backend.books]
}
