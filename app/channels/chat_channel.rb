class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    @chatroom = Chatroom.find(params[:id])
    if @chatroom
      stream_from "chatroom-#{@chatroom.id}-messages"
      logger.info "Subscribed to chatroom-#{@chatroom.id}-messages"
    else
      reject
      logger.warn "Failed to subscribe to chatroom-#{@chatroom.id}-messages"
    end
  end

  def speak(data)
    unless @chatoom
      logger.error "Failed to send message to chatroom-#{@chatroom.id}-messages"
      return
    end
    message = @chatroom.messages.create!(content: data['message'], user: current_user)

    if message.save
      ActionCable.server.broadcast(
        "chatroom-#{@chatroom.id}-messages",
        message: MessageSerializer.new(message)
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
