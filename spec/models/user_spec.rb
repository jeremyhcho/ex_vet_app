# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  profile_picture :string
#  status          :string
#  phone_number    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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
    it { should have_many :access_levels }
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
  end

  context 'callbacks' do
    context '#ensure_formatted_name' do
      before do
        subject.first_name = subject.first_name.downcase
        subject.last_name = subject.last_name.downcase
      end

      it 'should properly capitalize the first and last name' do
        subject.ensure_formatted_name

        expect(subject.first_name).to eq subject.first_name.capitalize
        expect(subject.last_name).to eq subject.last_name.capitalize
      end
    end
  end
end
