module Api
  module V1
    class CompaniesController < ApplicationController
      def index
        @companies = current_user.accessible_companies

        json_response @companies
      end

      def create
        @company = Company.create!(company_params)

        json_response @company
      end

      def update
        @company = Company.find(params[:id])
        @company.update_attributes!(company_params)

        json_response @company
      end

      def show
        @company = Company.find(params[:id])

        json_response @company
      end

      def destroy
        @company = Company.find(params[:id])
        @company.destroy!

        json_response(success: true)
      end

      private

      def company_params
        params.require(:company).permit(
          :name,
          :owner_id
        )
      end
    end
  end
end
