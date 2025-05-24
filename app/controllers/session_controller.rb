class SessionController < ApplicationController
    skip_before_action :authenticate_request

    def signup
        user = User.create!(user_params)

        if user.save
            token = JsonWebToken.encode(user_id: user.id)
            time = Time.now + 24.hours.to_i
            render json: { user: UserSerializer.new(user), token: token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :created
        else
            render json: { error: 'failed to create user' }, status: :not_acceptable
        end
    end

    def create
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            time = Time.now + 24.hours.to_i
            render json: { user: UserSerializer.new(user), token: token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
        else
            render json: { error: 'Invalid Username or Password' }, status: :unauthorized
        end
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end
end
