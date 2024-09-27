from fastapi import FastAPI
from starlette_exporter import PrometheusMiddleware, handle_metrics
from prometheus_client import Counter

app = FastAPI()

app.add_middleware(PrometheusMiddleware)
app.add_route("/metrics", handle_metrics)

request_counter = Counter('myapp_request_count', 'Total web app request count of my app')

@app.get("/")
async def read_root():
    request_counter.inc()
    return {"message": "Hello! This is the root of the API."}