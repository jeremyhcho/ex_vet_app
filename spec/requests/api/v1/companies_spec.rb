require 'rails_helper'

describe 'Companies API' do
  let(:user) do
    FactoryGirl.create :user, password: 'password'
  end

  let!(:company) do
    FactoryGirl.create :company, owner: user
  end

  before do
    sign_in_as!(user)
  end

  context '#index' do
    let(:api_call) do
      get '/api/v1/companies'
    end

    let(:expected_response) do
      [
        {
          id: company.id,
          name: company.name
        },
        {
          id: company2.id,
          name: company2.name
        }
      ]
    end

    let!(:company2) do
      FactoryGirl.create :company, owner: user
    end

    before do
      sign_in_as!(user)
    end

    it 'should return the companies the user has access to' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#create' do
    let(:api_call) do
      post '/api/v1/companies', params
    end

    let(:params) do
      {
        params: {
          company: {
            name: 'My Company Name',
            owner_id: user.id
          }
        }
      }
    end

    it 'should successfully create a company' do
      expect { api_call }.to change { Company.count }.by(1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response[:id]).to_not be_nil
    end
  end

  context '#update' do
    let(:api_call) do
      put "/api/v1/companies/#{company.id}", params
    end

    let(:params) do
      {
        params: {
          company: { name: 'My Updated Company Name' }
        }
      }
    end

    let(:expected_response) do
      {
        id: company.id,
        name: 'My Updated Company Name'
      }
    end

    it 'should properly update the company' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#show' do
    let(:api_call) do
      get "/api/v1/companies/#{company.id}"
    end

    let(:expected_response) do
      {
        id: company.id,
        name: company.name
      }
    end

    it 'should expose the company properly' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#destroy' do
    let(:api_call) do
      delete "/api/v1/companies/#{company.id}"
    end

    let!(:company) do
      FactoryGirl.create :company, owner: user
    end

    let(:expected_response) do
      { success: true }
    end

    it 'should successfully delete the company' do
      expect { api_call }.to change { Company.count }.by(-1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response).to eq expected_response
    end
  end
end
