import azure.functions as func
import uuid
import logging
import json
import os
from azure.cosmos import CosmosClient
from azure.cosmos.exceptions import CosmosResourceNotFoundError, CosmosHttpResponseError
from azure.identity import DefaultAzureCredential

# Instantiate the Function App
app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

# ==================================================
# Function: Version me 1
# Route: GET /versionme1
# ==================================================
@app.route(route="versionme1", methods=["GET"], auth_level=func.AuthLevel.FUNCTION)
def versionme1(req: func.HttpRequest) -> func.HttpResponse:
    """
Returns a JSON response with the version of the Function App.

Args:
    req (func.HttpRequest): The HTTP request object containing the payload.

Returns:
    func.HttpResponse: An HTTP response object. Returns a 200 status with JSON indicating version
    """
    logging.info('versionme1 function processed a request.')

    return func.HttpResponse(
        body=json.dumps({"version": "1.0.0"}),
        status_code=200,
        headers={"Content-Type": "application/json"}
    )

# ==================================================
# Function: Version me 1next
# Route: GET /versionme1next
# ==================================================
@app.route(route="versionme1next", methods=["GET"], auth_level=func.AuthLevel.FUNCTION)
def versionme1next(req: func.HttpRequest) -> func.HttpResponse:
    """
Returns a JSON response with the version of the Function App.

Args:
    req (func.HttpRequest): The HTTP request object containing the payload.

Returns:
    func.HttpResponse: An HTTP response object. Returns a 200 status with JSON indicating version
    """
    logging.info('versionme1 function processed a request.')

    return func.HttpResponse(
        body=json.dumps({"version": "1.3.0"}),
        status_code=200,
        headers={"Content-Type": "application/json"}
    )

# ==================================================
# Function: Version me 2
# Route: GET /versionme2
# ==================================================
@app.route(route="versionme2", methods=["GET"], auth_level=func.AuthLevel.FUNCTION)
def versionme2(req: func.HttpRequest) -> func.HttpResponse:
    """
Returns a JSON response with the version of the Function App.

Args:
    req (func.HttpRequest): The HTTP request object containing the payload.

Returns:
    func.HttpResponse: An HTTP response object. Returns a 200 status with JSON indicating version
    """
    logging.info('versionme1 function processed a request.')

    return func.HttpResponse(
        body=json.dumps({"version": "2.0.0"}),
        status_code=200,
        headers={"Content-Type": "application/json"}
    )