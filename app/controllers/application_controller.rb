class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :conversation_id, :turbo_native_app?

  private

  def conversation_id
    session[:conversation_id] ||= SecureRandom.uuid
  end

  def turbo_native_app?
    request.user_agent.to_s.include?("Turbo Native")
  end
end
