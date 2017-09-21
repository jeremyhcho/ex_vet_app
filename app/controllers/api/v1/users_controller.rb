module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [:create, :recover, :validate_reset, :update]
      before_action :validate_token_or_authorize_request, only: :update

      def create
        @user = User.create!(user_params)
        login!

        json_response(@user.serialize, :created)
      end

      def update
        @user = User.find(params[:id])
        @user.update_attributes!(user_params)
        Rails.cache.write("password_reset_token:#{params[:id]}", nil) if params[:token]

        json_response(@user.serialize)
      end

      def show
        @user = User.find(params[:id])

        json_response(@user.serialize)
      end

      def recover
        @user = User.find_by!(email: params[:email])
        RecoverPasswordMailer.send_recover_password(@user).deliver!

        json_response({ success: true })
      rescue Net::SMTPFatalError
        raise ExceptionHandler::BadRequest, 'Email was unable to be sent'
      end

      def validate_reset
        @user = User.find(params[:user_id])

        if valid_reset_token?(@user.id)
          json_response({ success: true })
        else
          raise ActiveRecord::RecordNotFound, 'Invalid reset token'
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :first_name,
          :last_name
        )
      end

      def validate_token_or_authorize_request
        return authorize_request unless params[:token]

        if !valid_reset_token?(params[:id])
          raise ExceptionHandler::AuthenticationError, 'Invalid reset token'
        end
      end

      def valid_reset_token?(id)
        Rails.cache.read("password_reset_token:#{id}") == params[:token]
      end
    end
  end
end
