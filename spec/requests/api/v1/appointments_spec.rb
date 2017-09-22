require 'rails_helper'

describe 'Appointments API' do
  let(:company) do
    FactoryGirl.create :company, owner: user
  end

  let(:user) do
    FactoryGirl.create :user, password: 'password'
  end

  let(:location) do
    FactoryGirl.create :location, company: company
  end

  context '#index' do
    let(:api_call) do
      get '/api/v1/appointments', params
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
    let(:api_call) do
      post '/api/v1/appointments', params
    end

    let(:params) do
      {
        params: {
          appointment: {
            from: 'Thu, 21 Sep 2017 11:00:00 GMT',
            to: 'Thu, 21 Sep 2017 12:00:00 GMT',
            description: 'Description',
            title: 'Title',
            location_id: location.id,
            company_id: company.id
          }
        }
      }
    end

    before do
      sign_in_as!(user)
    end

    it 'should create an appointment' do
      expect { api_call }.to change { Appointment.count }.by(1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response[:id]).to_not be_nil
    end
  end

  context '#update' do
    let(:api_call) do
      put "/api/v1/appointments/#{appointment.id}", params
    end

    let(:params) do
      {
        params: {
          appointment: {
            from: 'Thu, 21 Sep 2017 11:00:00 GMT',
            to: 'Thu, 21 Sep 2017 12:00:00 GMT',
            description: 'Description',
            title: 'Title',
            location_id: location.id,
            company_id: company.id
          }
        }
      }
    end

    let(:appointment) do
      FactoryGirl.create :appointment,
                         creator: user,
                         location: location,
                         company: company
    end

    let(:expected_response) do
      {
        id: appointment.id,
        from: '2017-09-21 11:00:00 UTC',
        to: '2017-09-21 12:00:00 UTC',
        title: 'Title',
        description: 'Description',
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
    end

    it 'should properly update the appointment' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#show' do
    let(:api_call) do
      get "/api/v1/appointments/#{appointment.id}"
    end

    let(:appointment) do
      FactoryGirl.create :appointment,
                         creator: user,
                         location: location,
                         company: company
    end

    let(:expected_response) do
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
    end

    it 'should expose the appointment properly' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#destroy' do
    let(:api_call) do
      delete "/api/v1/appointments/#{appointment.id}"
    end

    let!(:appointment) do
      FactoryGirl.create :appointment,
                         creator: user,
                         location: location,
                         company: company
    end

    let(:expected_response) do
      { success: true }
    end

    it 'should successfully remove the appointment' do
      expect { api_call }.to change { Appointment.count }.by(-1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response).to eq expected_response
    end
  end
end
