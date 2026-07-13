from copy import deepcopy
import time

from fastapi import FastAPI, Request

app = FastAPI(title="AgentSecOps Mock LLM")
received_requests: list[dict] = []


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "service": "mock-llm"}


@app.get("/v1/models")
def list_models() -> dict:
    return {
        "object": "list",
        "data": [
            {
                "id": "gpt-4",
                "object": "model",
                "created": 1686935002,
                "owned_by": "mock",
            }
        ],
    }


@app.post("/v1/chat/completions")
async def chat_completions(request: Request) -> dict:
    body = await request.json()
    received_requests.append(deepcopy(body))
    model = body.get("model", "gpt-4")
    messages = body.get("messages", [])
    user_content = messages[-1].get("content", "") if messages else "empty"

    return {
        "id": "chatcmpl-mock123",
        "object": "chat.completion",
        "created": int(time.time()),
        "model": model,
        "choices": [
            {
                "index": 0,
                "message": {
                    "role": "assistant",
                    "content": f"[Mock LLM Response to '{user_content[:30]}...']",
                },
                "finish_reason": "stop",
            }
        ],
        "usage": {"prompt_tokens": 10, "completion_tokens": 20, "total_tokens": 30},
    }


@app.get("/admin/requests")
def get_received_requests() -> dict:
    return {"count": len(received_requests), "requests": received_requests}


@app.post("/admin/reset")
def reset_received_requests() -> dict[str, int]:
    received_requests.clear()
    return {"count": 0}
