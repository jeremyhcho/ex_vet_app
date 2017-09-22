module Api
  module V1
    class AppointmentsController < ApplicationController
      def index
        @appointments = Appointment.where(company_id: params[:company_id])

        json_response @appointments, :ok, each_serializer: Appointments::ShowSerializer
      end

      def create
        @appointment = Appointment.create!(create_params)
        json_response(@appointment, :created, serializer: Appointments::ShowSerializer)
      end

      def update
        @appointment = Appointment.find(params[:id])
        @appointment.update_attributes!(appointment_params)

        json_response(@appointment, :ok, serializer: Appointments::ShowSerializer)
      end

      def show
        @appointment = Appointment.find(params[:id])
        json_response(@appointment, :ok, serializer: Appointments::ShowSerializer)
      end

      def destroy
        @appointment = Appointment.find(params[:id])
        @appointment.destroy!

        json_response(success: true)
      end

      private

      def appointment_params
        params.require(:appointment).permit(
          :from,
          :to,
          :title,
          :description,
          :location_id,
          :company_id
        )
      end

      def create_params
        appointment_params.merge(creator_id: current_user.id)
      end
    end
  end
end
