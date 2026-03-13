class ChatsController < ApplicationController
  def index
    @messages = Message.for_conversation(conversation_id)
    @new_message = Message.new
  end

  def clear
    Message.for_conversation(conversation_id).delete_all
    redirect_to root_path
  end
end
