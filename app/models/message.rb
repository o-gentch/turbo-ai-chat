class Message < ApplicationRecord
  ROLES = %w[user assistant].freeze

  validates :role, inclusion: { in: ROLES }
  validates :content, presence: true
  validates :conversation_id, presence: true

  scope :for_conversation, ->(id) { where(conversation_id: id).order(:created_at) }

  def user?
    role == "user"
  end

  def assistant?
    role == "assistant"
  end
end
