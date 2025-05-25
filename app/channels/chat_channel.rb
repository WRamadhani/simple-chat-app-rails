class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    @chatroom = Chatroom.find_by(id: params[:id])
    if @chatroom
      stream_from "chatroom-#{@chatroom.id}-messages"
      logger.info "Subscribed to chatroom-#{@chatroom.id}-messages"
    else
      reject
      logger.warn "Failed to subscribe to chatroom-#{@chatroom.id}-messages"
    end
  end

  def speak(data)
    logger.debug "Received data: #{data.inspect}"
    logger.info "Sending message to chatroom-#{@chatroom.id}-messages"
    unless @chatroom
      logger.error "Attempted to speak without a valid chatroom context"
      return
    end
    message = @chatroom.messages.create!(
      content: data['message'],
      user: current_user
    )
    # ActionCable.server.broadcast(
    #     "chatroom-#{@chatroom.id}-messages",
    #     message: MessageSerializer.new(message).serializable_hash
    # )

    if message.save
      logger.info "Saved message to chatroom-#{@chatroom.id}-messages"
      ActionCable.server.broadcast(
        "chatroom-#{@chatroom.id}-messages",
        { message: MessageSerializer.new(message).serializable_hash }
      )
      logger.info "Sent message to chatroom-#{@chatroom.id}-messages"
    else
      logger.error "Failed to send message to chatroom-#{@chatroom.id}-messages"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    logger.info "Unsubscribed from chatroom-#{@chatroom.id}-messages"
  end
end
