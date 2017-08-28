module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorize_request, only: :create

      def index
        head :no_content
      end

      def create
        @user = User.find_by_credentials(
          params[:user][:email],
          params[:user][:password]
        )

        if @user.nil?
          json_response({ message: 'Invalid email/password combination' }, :unauthorized)
        else
          login!
          json_response({ success: true })
        end
      end

      def destroy
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
