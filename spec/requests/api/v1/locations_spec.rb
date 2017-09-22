require 'rails_helper'

describe 'Locations API' do
  let(:company) do
    FactoryGirl.create :company, owner: user
  end

  let(:user) do
    FactoryGirl.create :user
  end

  context '#index' do
    let(:api_call) do
      get '/api/v1/locations', params
    end

    let(:company2) do
      FactoryGirl.create :company, owner: user
    end

    let!(:location) do
      FactoryGirl.create :location,
                         company: company
    end

    let!(:irrelevant_location) do
      FactoryGirl.create :location,
                         company: company2
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
          id: location.id,
          name: location.name,
          country: location.country,
          state: location.state,
          city: location.city,
          address: location.address,
          zip: location.zip
        }
      ]
    end

    it 'should return a list of locations for the correct company' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#create' do
    let(:api_call) do
      post '/api/v1/locations', params
    end

    let(:params) do
      {
        params: {
          location: {
            name: 'My First Store',
            country: 'US',
            state: 'CA',
            city: 'Los Angeles',
            address: '1231 Oscar Blvd.',
            zip: '91214',
            company_id: company.id
          }
        }
      }
    end

    it 'should create a location' do
      expect { api_call }.to change { Location.count }.by(1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response[:id]).to_not be_nil
    end
  end

  context '#update' do
    let(:api_call) do
      put "/api/v1/locations/#{location.id}", params
    end

    let!(:location) do
      FactoryGirl.create :location, company: company
    end

    let(:params) do
      {
        params: {
          location: {
            name: 'My First Store',
            country: 'US',
            state: 'CA',
            city: 'Los Angeles',
            address: '1231 Oscar Blvd.',
            zip: '91214'
          }
        }
      }
    end

    let(:expected_response) do
      {
        id: location.id,
        name: 'My First Store',
        country: 'US',
        state: 'CA',
        city: 'Los Angeles',
        address: '1231 Oscar Blvd.',
        zip: '91214'
      }
    end

    it 'should return the updated location' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#show' do
    let(:api_call) do
      get "/api/v1/locations/#{location.id}"
    end

    let!(:location) do
      FactoryGirl.create :location, company: company
    end

    let(:expected_response) do
      {
        id: location.id,
        name: location.name,
        country: location.country,
        state: location.state,
        city: location.city,
        address: location.address,
        zip: location.zip
      }
    end

    it 'should return the location details' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#destroy' do
    let(:api_call) do
      delete "/api/v1/locations/#{location.id}"
    end

    let!(:location) do
      FactoryGirl.create :location, company: company
    end

    let(:expected_response) do
      { success: true }
    end

    it 'should delete the location' do
      expect { api_call }.to change { Location.count }.by(-1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response).to eq expected_response
    end
  end
end
