class ChatroomsController < ApplicationController
    def index
        @chatrooms = Chatroom.all
        render json: @chatrooms, each_serializer: ChatroomSerializer, status: :ok
    end

    def show
        puts "Params ID: #{params[:id]}"
        begin
            @chatroom = Chatroom.find(params[:id])
            @messages = @chatroom.messages.chronological
            render json: {
                chatroom: ChatroomSerializer.new(@chatroom),
                messages: @messages.map { |message| MessageSerializer.new(message) }    
            }, status: :ok
        rescue ActiveRecord::RecordNotFound => e
            render json: { errors: e.message }, status: :not_found
        end
    end

    def create
        @chatroom = Chatroom.create!(chatroom_params)
        if @chatroom.save
            render json: @chatroom, serializer: ChatroomSerializer, status: :created
        else
            render json: { error: @chatoom.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def chatroom_params
        params.require(:chatroom).permit(:name)
    end
end
