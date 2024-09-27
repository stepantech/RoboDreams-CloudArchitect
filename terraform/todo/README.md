# ToDo demo of Containers as a Service vs. Serverless
This demo deploys simple ToDo web application in two different ways: using containers and Azure Container Apps and without containers user serverless Azure Functions and Azure Static Web Apps.

Architecture consist of:
- ToDo API with basic CRUD operations
- PostgreSQL database
- AI processing microservices that listens to ToDo created event and enrich data with AI generated motivational message
- React frontend
