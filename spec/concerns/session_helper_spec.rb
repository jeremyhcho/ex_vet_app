require 'rails_helper'

describe SessionHelper do
  subject { TestController.new }

  let(:params) do
    {}
  end

  let(:user) do
    FactoryGirl.create :user
  end

  let(:session) do
    FactoryGirl.create :session, user: user
  end

  let(:session_stub) do
    {}
  end

  let(:cookies_stub) do
    {}
  end

  let(:random_token) do
    SecureRandom.base64
  end

  before do
    class TestController < ApplicationController; end

    allow(subject).to receive(:params).and_return params
    allow(subject).to receive(:session).and_return(session_stub)
    allow(subject).to receive(:cookies).and_return(cookies_stub)
    allow(subject).to receive(:current_session).and_return(session)
  end

  after do
    Object.send :remove_const, :TestController
  end

  context '#login!' do
    before do
      subject.instance_variable_set(:@user, user)
    end

    it 'should set the proper session and cookies' do
      subject.login!

      expect(subject.session[:session_token]).to be_a_kind_of String
      expect(subject.session[:expires_at]).to be_a_kind_of Time
      expect(subject.send(:cookies)[:authorized]).to be_a_kind_of Hash
      expect(subject.send(:cookies)[:remember_me]).to be_a_kind_of Hash
    end
  end

  context '#current_user' do
    let(:session_stub) do
      { session_token: 'irrelevant' }
    end

    it 'should properly return the current signed in user' do
      expect(subject.current_user).to eq user
    end
  end

  context '#logged_in?' do
    context 'when user is not logged in' do
      before do
        allow(subject).to receive(:current_user).and_return nil
      end

      it 'should return false' do
        expect(subject.logged_in?).to eq false
      end
    end

    context 'when user is logged in' do
      before do
        allow(subject).to receive(:current_user).and_return user
      end

      it 'should return true' do
        expect(subject.logged_in?).to eq true
      end
    end
  end

  context '#logout!' do
    let(:session_stub) do
      { session_token: 'irrelevant' }
    end

    it 'should destroy the current session' do
      expect { subject.logout! }.to change { Session.count }.by(-1)
    end

    it 'should unset the session_token of the session' do
      subject.logout!

      expect(subject.session[:session_token]).to eq nil
    end
  end

  context '#current_session' do
    let(:session_stub) do
      { session_token: random_token }
    end

    let!(:session) do
      FactoryGirl.create :session, user: user, token: random_token
    end

    it 'should return the current session' do
      expect(subject.current_session).to eq session
    end
  end

  context '#session_expired?' do
    let(:session_stub) do
      { expires_at: time_stub }
    end

    context 'when not expired' do
      let(:time_stub) do
        (Time.now + 1.week).to_s
      end

      it 'should return false' do
        expect(subject.session_expired?).to eq false
      end
    end

    context 'when expired' do
      let(:time_stub) do
        (Time.now - 1.second).to_s
      end

      it 'should return true' do
        expect(subject.session_expired?).to eq true
      end
    end
  end

  context '#valid_remember_me?' do
    let(:session) do
      FactoryGirl.create :session, user: user, remember_me: random_token
    end

    context "when remember_me in params doesnt match the current sessions's remember_me" do
      let(:cookies_stub) do
        { remember_me: SecureRandom.base64 }
      end

      it 'should return false' do
        expect(subject.valid_remember_me?).to eq false
      end
    end

    context 'when remember_me in params correctly matches the current sessions remember_me' do
      let(:cookies_stub) do
        { remember_me: random_token }
      end

      it 'should return true' do
        expect(subject.valid_remember_me?).to eq true
      end
    end
  end

  context '#session_inactive?' do
    context 'when updated_at is longer than 30 minutes ago' do
      before do
        session.updated_at = Time.now - 1.hour
      end

      it 'should return true' do
        expect(subject.session_inactive?).to eq true
      end
    end

    context 'when updated_at is within 30 minutes from now' do
      it 'should return false' do
        expect(subject.session_inactive?).to eq false
      end
    end
  end
end
