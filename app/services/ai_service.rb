class AiService
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com"

  SYSTEM_PROMPT = "Ты полезный ассистент. Отвечай кратко и по делу."
  MODEL = "gemini-2.5-flash"

  def chat(messages)
    response = self.class.post(
      "/v1beta/models/#{MODEL}:generateContent",
      query: { key: Rails.application.credentials.gemini_api_key! },
      headers: { "Content-Type" => "application/json" },
      body: {
        systemInstruction: {
          parts: [ { text: SYSTEM_PROMPT } ]
        },
        contents: messages.map do |m|
          {
            role: m[:role] == "assistant" ? "model" : "user",
            parts: [ { text: m[:content] } ]
          }
        end,
        generationConfig: {
          maxOutputTokens: 1000,
          temperature: 0.7
        }
      }.to_json,
      timeout: 30
    )

    body = response.parsed_response
    body = JSON.parse(body) if body.is_a?(String)

    if response.success?
      body.dig("candidates", 0, "content", "parts", 0, "text").to_s.strip
    else
      "Ошибка API: #{body.dig("error", "message") || response.code}"
    end
  rescue StandardError => e
    "Не удалось получить ответ: #{e.message}"
  end
end
