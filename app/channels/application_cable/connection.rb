module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      # ActionCable.server.logger.add_tags 'ActionCable', current_user.username
      logger.add_tags 'ActionCable', current_user.username
    end

    private

    def find_verified_user
      begin
        if (token = request.query_parameters['token'])
          decoded_token = JsonWebToken.decode(token)
          if decoded_token && (user = User.find(decoded_token[:user_id]))
            user
          else
            reject_unauthorized_connection
          end
        else
          reject_unauthorized_connection
        end
      rescue JWT::DecodeError => e
        logger.error "Action Cable Token Decode Error: #{e.message}"
        reject_unauthorized_connection
      rescue ActiveRecord::RecordNotFound => e
        logger.error "Action Cable User Not Found Error: #{e.message}"
      end
    end
  end
end
