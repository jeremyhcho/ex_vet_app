module Api
  module V1
    class LocationsController < ApplicationController
      def index
        @locations = Location.where(company_id: params[:company_id])
        json_response @locations
      end

      def create
        @location = Location.create!(location_params)
        json_response @location
      end

      def update
        @location = Location.find(params[:id])
        @location.update_attributes!(location_params)

        json_response @location
      end

      def show
        @location = Location.find(params[:id])
        json_response @location
      end

      def destroy
        @location = Location.find(params[:id])
        @location.destroy!

        json_response(success: true)
      end

      private

      def location_params
        params.require(:location).permit(
          :name,
          :country,
          :state,
          :city,
          :address,
          :zip,
          :company_id
        )
      end
    end
  end
end
