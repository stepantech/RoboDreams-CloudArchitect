from dapr.ext.workflow import WorkflowRuntime, DaprWorkflowContext, WorkflowActivityContext
from dapr.clients import DaprClient

def hello_act(ctx: WorkflowActivityContext, input):
    print(f"Hello {input}")
    return f"Hello {input}"

def hello_world_wf(ctx: DaprWorkflowContext, input):
    print(f"Hello World! {input}")
    yield ctx.call_activity(hello_act, input=1)

dapr = DaprClient()
workflowRuntime = WorkflowRuntime()
workflowRuntime.register_workflow(hello_world_wf)
workflowRuntime.register_activity(hello_act)
workflowRuntime.start()