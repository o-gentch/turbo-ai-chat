class AiService
  include HTTParty
  base_uri "https://api.openai.com"

  SYSTEM_PROMPT = "Ты полезный ассистент. Отвечай кратко и по делу."

  def chat(messages)
    response = self.class.post(
      "/v1/chat/completions",
      headers: {
        "Authorization" => "Bearer #{ENV.fetch("OPENAI_API_KEY")}",
        "Content-Type" => "application/json"
      },
      body: {
        model: "gpt-4o-mini",
        messages: [ { role: "system", content: SYSTEM_PROMPT } ] + messages,
        max_tokens: 1000,
        temperature: 0.7
      }.to_json,
      timeout: 30
    )

    if response.success?
      response.dig("choices", 0, "message", "content").to_s.strip
    else
      "Ошибка API: #{response["error"]&.dig("message") || response.code}"
    end
  rescue StandardError => e
    "Не удалось получить ответ: #{e.message}"
  end
end
