require 'rails_helper'

describe 'Appointments API' do
  context '#index' do
    let(:api_call) do
      get '/api/v1/appointments', params
    end

    let(:company) do
      FactoryGirl.create :company, owner: user
    end

    let(:user) do
      FactoryGirl.create :user
    end

    let(:location) do
      FactoryGirl.create :location, company: company
    end

    let!(:appointment) do
      FactoryGirl.create :appointment,
                         creator: user,
                         company: company,
                         location: location
    end

    let(:params) do
      {
        params: {
          company_id: company.id
        }
      }
    end

    let(:expected_response) do
      [
        {
          id: appointment.id,
          from: appointment.from.to_s,
          to: appointment.to.to_s,
          title: appointment.title,
          description: appointment.description,
          creator: {
            id: user.id,
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name,
            profile_picture: nil,
            status: nil,
            phone_number: user.phone_number
          }
        }
      ]
    end

    before do
      api_call
    end

    it 'should return the proper response' do
      expect(json_response).to eq expected_response
    end
  end

  context '#create' do
  end

  context '#update' do
  end

  context '#show' do
  end

  context '#destroy' do
  end
end
