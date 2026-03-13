class MessagesController < ApplicationController
  def create
    content = params.dig(:message, :content).to_s.strip
    return redirect_to root_path if content.blank?

    @user_message = Message.create!(
      role: "user",
      content: content,
      conversation_id: conversation_id
    )

    history = Message.for_conversation(conversation_id).map do |m|
      { role: m.role, content: m.content }
    end

    ai_content = AiService.new.chat(history)

    @ai_message = Message.create!(
      role: "assistant",
      content: ai_content,
      conversation_id: conversation_id
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end
end
