module Api
  module V1
    class ProductsController < ApplicationController
      def index
        @products = Product.where(company_id: params[:company_id])

        json_response @products
      end

      def create
        @product = Product.create!(product_params)

        json_response @product
      end

      def update
        @product = Product.find(params[:id])
        @product.update_attributes!(product_params)

        json_response @product
      end

      def show
        @product = Product.find(params[:id])

        json_response @product
      end

      def destroy
        @product = Product.find(params[:id])
        @product.destroy!

        json_response(success: true)
      end

      private

      def product_params
        params.require(:product).permit(
          :title,
          :description,
          :image_url,
          :price_cents,
          options_attributes: [
            :id,
            :option_name,
            option_values_attributes: [
              :id,
              :option_value
            ]
          ]
        ).merge(company_id: params[:company_id])
      end
    end
  end
end
