module Api
  module V1
    class AppointmentsController < ApplicationController
      def index
        @appointments = Appointment.where(company_id: params[:company_id])

        json_response @appointments, :ok, each_serializer: Appointments::ShowSerializer
      end

      def create
      end

      def update
      end

      def show
      end

      def destroy
      end
    end

  end
end
