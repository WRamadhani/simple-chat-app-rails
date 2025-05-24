class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  validates :content, presence: true, length: {  minimum: 1, maximum: 1000 }

  scope :last_message, -> { order(created_at: :desc).limit(1) }
  scope :recent, -> { order(created_at: :desc).limit(10) }

  # scope :unread, -> { where(read_at: nil) }
  scope :chronological, -> { order(created_at: :asc) }
end
