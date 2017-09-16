module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorize_request, only: :login

      def login
        @user = User.find_by_credentials(
          params[:user][:email],
          params[:user][:password]
        )

        if @user.nil?
          json_response({ message: 'Invalid email/password combination' }, :unprocessable_entity)
        else
          login!
          json_response(@user.serialize)
        end
      end

      def logout
        @user = current_user

        if @user
          logout!
          head :no_content
        else
          json_response({ message: 'Nobody is signed in!' }, :bad_request)
        end
      end
    end
  end
end
