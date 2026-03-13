Rails.application.routes.draw do
  root "chats#index"

  delete "chat/clear", to: "chats#clear", as: :clear_chat

  resources :messages, only: [ :create ]

  get "up" => "rails/health#show", as: :rails_health_check
end
