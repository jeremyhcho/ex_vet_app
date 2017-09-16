require 'rails_helper'

describe User, type: :model do
  subject { FactoryGirl.build :user }

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).with_message 'Oops, this email has already been registered!' }
    it { should validate_length_of(:password).is_at_least 6 }
  end

  context 'associations' do
    it { should have_many :sessions }
  end

  context 'class methods' do
    let(:email) { 'test@test.com' }
    let(:password) { 'password' }
    let!(:user) do
      FactoryGirl.create :user, email: email, password: password
    end

    context '#find_by_credentials' do
      it 'should return the user with correct credentials' do
        expect(User.find_by_credentials(email, password)).to eq user
      end
    end
  end

  context 'instance methods' do
    context '#password=' do
      it 'should properly set the password_digest with bcrypt' do
        subject.password = 'password'
        expect(BCrypt::Password.new(subject.password_digest).is_password?('password'))
          .to eq true
      end
    end

    context '#password?' do
      it 'should check the passwords properly' do
        subject.password = 'password'
        expect(subject.password?('password')).to eq true
      end
    end

    context '#serialize' do
      it 'should call the correct serializer' do
        expect_any_instance_of(Users::ShowSerializer).to receive(:serializable_hash)

        subject.serialize
      end
    end
  end
end
