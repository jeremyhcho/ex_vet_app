module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: :create

      def create
        @user = User.create!(user_params)
        login!

        json_response(@user.serialize, :created)
      end

      def show
        @user = User.find(params[:id])

        json_response(@user.serialize)
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
    end
  end
end
