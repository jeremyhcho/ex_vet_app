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
        {
          messages: {
            'email' => ['Oops, this email has already been registered!']
          }
        }
      end

      it 'should raise an error' do
        expect(response.status).to eq 422
        expect(json_response).to eq expected_response
      end
    end
  end

  context '#update' do
    let(:random_token) do
      SecureRandom.base64
    end

    let(:user) do
      FactoryGirl.create :user
    end

    let(:api_call) do
      put "/api/v1/users/#{user.id}", params
    end

    let(:params) do
      {
        params: {
          id: user.id,
          token: random_token,
          user: {
            email: 'from@example.com',
            first_name: 'Jeremy',
            last_name: 'Cho'
          }
        }
      }
    end

    context 'with valid reset token' do
      before do
        allow(Rails.cache)
          .to receive(:read)
          .with(user.password_reset_token_cache_key)
          .and_return random_token

        api_call
      end

      context 'and successful request' do
        let(:expected_response) do
          {
            id: user.id,
            email: 'from@example.com',
            first_name: 'Jeremy',
            last_name: 'Cho',
            profile_picture: nil,
            status: nil,
            phone_number: user.phone_number
          }
        end

        it 'should return the expected response' do
          expect(json_response).to eq expected_response
        end
      end

      context 'and unsuccessful request' do
        let(:params) do
          {
            params: {
              id: user.id,
              token: random_token,
              user: {
                email: 'from@example.com',
                first_name: 'Jeremy',
                last_name: 'Cho',
                password: 'abcd'
              }
            }
          }
        end

        let(:expected_response) do
          {
            messages: {
              'password' => ['is too short (minimum is 6 characters)']
            }
          }
        end

        before do
          api_call
        end

        it 'should return the expected error' do
          expect(response.status).to eq 422
          expect(json_response).to eq expected_response
        end
      end
    end

    context 'with invalid reset token' do
      let(:some_other_token) do
        SecureRandom.base64
      end

      let(:expected_response) do
        {
          messages: {
            'unauthorized' => 'Invalid reset token'
          }
        }
      end

      before do
        allow(Rails.cache)
          .to receive(:read)
          .with(user.password_reset_token_cache_key)
          .and_return some_other_token

        api_call
      end

      it 'should not update the user successfully' do
        expect(response.status).to eq 401
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

  context '#validate_reset' do
    let(:random_token) do
      SecureRandom.base64
    end

    let(:params) do
      {
        params: {
          user_id: user.id,
          token: random_token
        }
      }
    end

    let(:user) do
      FactoryGirl.create :user
    end

    let(:api_call) do
      get '/api/v1/users/validate_reset', params
    end

    context 'with valid token' do
      let(:expected_response) do
        { success: true }
      end

      before do
        allow(Rails.cache)
          .to receive(:read)
          .with(user.password_reset_token_cache_key)
          .and_return random_token

        api_call
      end

      it 'should return a success message' do
        expect(json_response).to eq expected_response
      end
    end

    context 'with invalid token' do
      let(:expected_response) do
        {
          messages: {
            'not_found' => 'Invalid reset token'
          }
        }
      end

      let(:some_other_token) do
        SecureRandom.base64
      end

      before do
        allow(Rails.cache)
          .to receive(:read)
          .with(user.password_reset_token_cache_key)
          .and_return some_other_token

        api_call
      end

      it 'should return a failure message' do
        expect(json_response).to eq expected_response
      end
    end
  end

  context '#recover' do
    let(:params) do
      {
        params: {
          email: user.email
        }
      }
    end

    let(:mailer_double) do
      double('RecoverPasswordMailer')
    end

    let(:api_call) do
      post '/api/v1/users/recover', params
    end

    let!(:user) do
      FactoryGirl.create :user
    end

    before do
      allow(RecoverPasswordMailer)
        .to receive(:send_recover_password)
        .and_return(mailer_double)
    end

    context 'when the email gets sent successfully' do
      let(:expected_response) do
        { success: true }
      end

      before do
        allow(mailer_double)
          .to receive(:deliver!)
          .and_return true

        api_call
      end

      it 'should return the expected response' do
        expect(json_response).to eq expected_response
      end
    end

    context 'when the email fails to send' do
      let(:expected_response) do
        {
          messages: {
            'bad_request' => 'Email was unable to be sent'
          }
        }
      end

      before do
        allow(mailer_double)
          .to receive(:deliver!)
          .and_raise Net::SMTPFatalError

        api_call
      end

      it 'should return the expected error' do
        expect(response.status).to eq 400
        expect(json_response).to eq expected_response
      end
    end
  end
end
