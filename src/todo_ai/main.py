import os
from azure.servicebus import ServiceBusClient, ServiceBusMessage
from dotenv import load_dotenv
from openai import AzureOpenAI
import json
import requests

# Load environment variables
load_dotenv()

# Azure Service Bus configuration
SERVICE_BUS_CONNECTION_STRING = os.getenv("SERVICE_BUS_CONNECTION_STRING")
SERVICE_BUS_TOPIC_NAME = os.getenv("SERVICE_BUS_TOPIC_NAME")
SERVICE_BUS_SUBSCRIBER_NAME = os.getenv("SERVICE_BUS_SUBSCRIBER_NAME")

# Azure OpenAI configuration
AZURE_OPENAI_API_KEY = os.getenv("AZURE_OPENAI_API_KEY")
AZURE_OPENAI_ENDPOINT = os.getenv("AZURE_OPENAI_ENDPOINT")
AZURE_OPENAI_DEPLOYMENT = os.getenv("AZURE_OPENAI_DEPLOYMENT")

# Todo service configuration
TODO_BASE_URL = os.getenv("TODO_BASE_URL")

client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_API_KEY"),
    api_version="2024-02-01",
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
)


def ask_ai(label, description):
    prompt = f"""
    INSTRUCTIONS:
    You task is generate very short motivational speech for ToDo item that use has created. You will be presented with label and description of the ToDo item. 
    You need to generate motivational speech that will encourage user to complete the task.
    You may use quotes, proverbs, or any other motivational content to generate the speech.
    Be friendly and encouraging in your speech.
    Be funny and cool.
    If user writes in English, you should respond in English. If user writes in Czech, you should respond in Czech.

    LABEL: {label}
    DESCRIPTION: {description}
    """
    messages = [{"role": "system", "content": prompt}]
    response = client.chat.completions.create(
        model=AZURE_OPENAI_DEPLOYMENT, messages=messages, max_tokens=200)
    print(response.choices[0].message.content)
    return response.choices[0].message.content


def store_ai_recommendation(id, label, description, state, due_date, ai_recommendation):
    url = f"{TODO_BASE_URL}/api/todos/{id}"
    headers = {
        "Content-Type": "application/json"
    }
    data = {
        "label": label,
        "description": description,
        "state": state,
        "due_date": due_date,
        "ai_recommendation": ai_recommendation
    }
    response = requests.put(url, headers=headers, data=json.dumps(data))
    if response.status_code == 200:
        print(f"Successfully updated ToDo item with ID {id}")
        return True
    else:
        print(
            f"Failed to update ToDo item with ID {id}. Status code: {response.status_code}, Response: {response.text}")
        return False


def receive_messages():
    servicebus_client = ServiceBusClient.from_connection_string(
        SERVICE_BUS_CONNECTION_STRING)
    with servicebus_client:
        receiver = servicebus_client.get_subscription_receiver(
            topic_name=SERVICE_BUS_TOPIC_NAME,
            subscription_name=SERVICE_BUS_SUBSCRIBER_NAME
        )
        with receiver:
            for msg in receiver:
                print(f"Received message: {msg}")
                message_body = json.loads(str(msg))
                id = message_body.get("id")
                label = message_body.get("label")
                description = message_body.get("description")
                state = message_body.get("state")
                due_date = message_body.get("due_date")
                ai_recommendation = ask_ai(label, description)
                if store_ai_recommendation(id=id, label=label, description=description, state=state, due_date=due_date, ai_recommendation=ai_recommendation):
                    receiver.complete_message(msg)

if __name__ == "__main__":
    receive_messages()
