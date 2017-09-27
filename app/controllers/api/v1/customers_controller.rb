module Api
  module V1
    class CustomersController < ApplicationController
      def index
        @customers = Customer.where(company_id: params[:company_id])

        json_response @customers
      end

      def create
        @customer = Customer.create!(customer_params)

        json_response @customer
      end

      def update
        @customer = Customer.find(params[:id])
        @customer.update_attributes!(customer_params)

        json_response @customer
      end

      def show
        @customer = Customer.find(params[:id])

        json_response @customer
      end

      def destroy
        @customer = Customer.find(params[:id])
        @customer.destroy!

        json_response(success: true)
      end

      private

      def customer_params
        params.require(:customer).permit(
          :first_name,
          :last_name,
          :company_name,
          :address,
          :email,
          :phone_number
        ).merge(company_id: params[:company_id])
      end
    end

  end
end
