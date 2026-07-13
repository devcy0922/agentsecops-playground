wrk.method = "POST"
wrk.body   = '{"model": "gpt-4", "messages": [{"role": "user", "content": "Hello Aegis!"}]}'
wrk.headers["Content-Type"] = "application/json"
wrk.headers["Authorization"] = "Bearer aegis-demo-admin"
