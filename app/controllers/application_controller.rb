class ApplicationController < ActionController::API
    before_action :authenticate_request

    attr_reader :current_user

    private

    def authenticate_request
        # @current_user = AuthorizeApiRequest.call(request.headers).result
        # render json: { error: 'Not Authorized' }, status: 401 unless @current_user
        header = request.headers['Authorization']
        token = header.split(' ').last if header

        if token
            begin
                @decoded = JsonWebToken.decode(token)
                @current_user = User.find(@decoded[:user_id])
            rescue ActiveRecord::RecordNotFound => e
                render json: { errors: e.message }, status: :unauthorized
                rescue JWT::DecodeError => e
                render json: { errors: e.message }, status: :unauthorized
            end
        else
            render json: { errors: 'Missing token' }, status: :unauthorized
        end
    end
end
