require 'rails_helper'

describe 'Sessions API' do
  context '#create' do
    before do
      post '/api/v1/login', params
    end

    context 'with the correct credentials' do
      let(:user) do
        FactoryGirl.create :user, password: 'password'
      end

      let(:params) do
        {
          params: {
            user: {
              email: user.email,
              password: 'password'
            }
          }
        }
      end

      let(:expected_response) do
        {
          id: user.id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          phone_number: user.phone_number,
          profile_picture: nil,
          status: nil
        }
      end

      it 'should return the expected response' do
        expect(json_response).to eq expected_response
      end
    end

    context 'with correct email but incorrect password' do
      let(:user) do
        FactoryGirl.create :user, password: 'password'
      end

      let(:params) do
        {
          params: {
            user: {
              email: user.email,
              password: 'password1'
            }
          }
        }
      end

      let(:expected_response) do
        {
          messages: {
            unauthorized: 'Invalid email/password combination'
          }
        }
      end

      it 'should return the correct error' do
        expect(json_response).to eq expected_response
      end
    end

    context 'with incorrect email' do
      let(:user) do
        FactoryGirl.create :user
      end

      let(:params) do
        {
          params: {
            user: {
              email: 'email@email.com',
              password: 'password'
            }
          }
        }
      end

      let(:expected_response) do
        {
          messages: {
            unauthorized: 'Invalid email/password combination'
          }
        }
      end

      it 'should return the correct error' do
        expect(json_response).to eq expected_response
      end
    end
  end

  context '#destroy' do
    let(:api_call) do
      delete '/api/v1/logout'
    end

    let(:user) do
      FactoryGirl.create :user
    end

    let(:session) do
      FactoryGirl.create :session, user: user
    end

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_session)
        .and_return session

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return user
    end

    context 'on successful logout' do
      it 'should destroy the current session' do
        expect { api_call }.to change { Session.count }.by(-1)
      end
    end

    context 'when current_user doesnt exist' do
      it 'should return the expected response' do
        api_call

        expect(response.body).to eq ''
      end
    end
  end
end
