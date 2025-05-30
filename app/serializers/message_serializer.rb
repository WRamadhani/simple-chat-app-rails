class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :chatroom
end
