require 'rails_helper'

describe 'Customers API' do
  let(:company) do
    FactoryGirl.create :company, owner: user
  end

  let(:user) do
    FactoryGirl.create :user, password: 'password'
  end

  before do
    sign_in_as!(user)
  end

  context '#index' do
    let(:api_call) do
      get "/api/v1/companies/#{company.id}/customers"
    end

    let(:company2) do
      FactoryGirl.create :company, owner: user
    end

    let!(:customer) do
      FactoryGirl.create :customer, company: company
    end

    let!(:customer2) do
      FactoryGirl.create :customer, company: company2
    end

    let(:expected_response) do
      [
        {
          id: customer.id,
          first_name: customer.first_name,
          last_name: customer.last_name,
          address: customer.address,
          email: customer.email,
          phone_number: customer.phone_number,
          company_name: customer.company_name
        }
      ]
    end

    it 'should return the customers under the company' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#create' do
    let(:api_call) do
      post "/api/v1/companies/#{company.id}/customers", params
    end

    let(:params) do
      {
        params: {
          customer: {
            first_name: 'Jeremy',
            last_name: 'Cho',
            address: '1231 Sunny Ln',
            email: 'from@example.com',
            company_name: 'My Cool Company',
            phone_number: '888-888-8888'
          }
        }
      }
    end

    it 'should successfully create a customer' do
      expect { api_call }.to change { Customer.count }.by(1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response[:id]).to_not be_nil
    end
  end

  context '#update' do
    let(:api_call) do
      put "/api/v1/companies/#{company.id}/customers/#{customer.id}", params
    end

    let!(:customer) do
      FactoryGirl.create :customer, company: company
    end

    let(:params) do
      {
        params: {
          customer: {
            first_name: 'Jeremy',
            last_name: 'Cho',
            address: '1231 Sunny Ln',
            email: 'from@example.com',
            company_name: 'My Cool Company',
            phone_number: '888-888-8888'
          }
        }
      }
    end

    let(:expected_response) do
      {
        id: customer.id,
        first_name: 'Jeremy',
        last_name: 'Cho',
        address: '1231 Sunny Ln',
        email: 'from@example.com',
        company_name: 'My Cool Company',
        phone_number: '888-888-8888'
      }
    end

    it 'should return the updated customer' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#show' do
    let(:api_call) do
      get "/api/v1/companies/#{company.id}/customers/#{customer.id}"
    end

    let!(:customer) do
      FactoryGirl.create :customer, company: company
    end

    let(:expected_response) do
      {
        id: customer.id,
        first_name: customer.first_name,
        last_name: customer.last_name,
        address: customer.address,
        email: customer.email,
        company_name: customer.company_name,
        phone_number: customer.phone_number
      }
    end

    it 'should return the customer details' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#destroy' do
    let(:api_call) do
      delete "/api/v1/companies/#{company.id}/customers/#{customer.id}"
    end

    let!(:customer) do
      FactoryGirl.create :customer, company: company
    end

    let(:expected_response) do
      { success: true }
    end

    it 'should successfully remove the customer' do
      expect { api_call }.to change { Customer.count }.by(-1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response).to eq expected_response
    end
  end
end
