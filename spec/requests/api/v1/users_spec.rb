require 'rails_helper'

describe 'Users API' do
  context '#create' do
    before do
      post '/api/v1/users', params
    end

    context 'when successful' do
      let(:params) do
        {
          params: {
            user: {
              email: 'email@email.com',
              password: 'password',
              first_name: 'Stevie',
              last_name: 'Wonder'
            }
          }
        }
      end

      let(:expected_response) do
        {
          id: User.last.id,
          email: 'email@email.com',
          first_name: 'Stevie',
          last_name: 'Wonder',
          profile_picture: nil,
          status: nil,
          phone_number: nil
        }
      end

      it 'should create a new user' do
        expect(json_response).to eq expected_response
      end
    end

    context 'when the email has already been registered' do
      let(:user) do
        FactoryGirl.create :user
      end

      let(:params) do
        {
          params: {
            user: {
              email: user.email,
              password: 'password',
              first_name: 'Stevie',
              last_name: 'Wonder'
            }
          }
        }
      end

      let(:expected_response) do
        { email: ['Oops, this email has already been registered!'] }
      end

      it 'should raise an error' do
        expect(response.status).to eq 422
        expect(json_response).to eq expected_response
      end
    end
  end

  context '#show' do
    let(:user) do
      FactoryGirl.create :user
    end

    let(:expected_response) do
      {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        profile_picture: nil,
        status: nil,
        phone_number: user.phone_number
      }
    end

    before do
      get "/api/v1/users/#{user.id}"
    end

    it 'should expose the user properly' do
      expect(json_response).to eq expected_response
    end
  end
end
