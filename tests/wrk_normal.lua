wrk.method = "POST"
wrk.body   = '{"model": "gpt-4", "messages": [{"role": "user", "content": "Hello Aegis!"}]}'
wrk.headers["Content-Type"] = "application/json"
local gateway_api_key = os.getenv("PLAYGROUND_GATEWAY_API_KEY")
if not gateway_api_key or gateway_api_key == "" then
  error("PLAYGROUND_GATEWAY_API_KEY를 설정하세요")
end
wrk.headers["Authorization"] = "Bearer " .. gateway_api_key
