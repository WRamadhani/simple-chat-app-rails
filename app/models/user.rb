class User < ApplicationRecord
    has_many :messages
    has_many :chatroom, through: :messages

    has_secure_password
    validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
end
