module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorize_request, only: :login
      skip_before_action :authorize_company

      def login
        @user = User.find_by_credentials(
          params[:user][:email],
          params[:user][:password]
        )

        if @user.nil?
          raise ExceptionHandler::AuthenticationError, 'Invalid email/password combination'
        else
          login!
          json_response @user
        end
      end

      def logout
        @user = current_user

        if @user
          logout!
          head :no_content
        else
          raise ExceptionHandler::BadRequest, 'Nobody is signed in!'
        end
      end
    end
  end
end
