# == Schema Information
#
# Table name: sessions
#
#  id          :integer          not null, primary key
#  token       :string           not null
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  remember_me :string
#

require 'rails_helper'

describe Session, type: :model do
  subject { FactoryGirl.build :session }

  context 'validations' do
    it { should validate_presence_of :token }
  end

  context 'associations' do
    it { should belong_to :user }
  end

  context 'instance methods' do
    let(:random_token) do
      SecureRandom.base64
    end

    context '#generate_token' do
      it 'should not generate a new token if one exists' do
        expect(subject.generate_token).to eq subject.token
      end

      it 'should set the token if not set' do
        subject.token = nil
        expect(subject.generate_token).to be_a_kind_of String
      end
    end

    context '#hash_token' do
      let(:session) do
        FactoryGirl.create :session, token: random_token, user: user
      end

      let(:user) do
        FactoryGirl.create :user
      end

      it 'should hash the token' do
        expect(session.token).to eq Digest::SHA256.hexdigest(random_token)
      end
    end

    context '#hash_remember_me' do
      let(:user) do
        FactoryGirl.create :user
      end

      context 'when remember_me is not present' do
        let(:session) do
          FactoryGirl.create :session, remember_me: nil, user: user
        end

        it 'should not hash the remember_me field' do
          expect(session.remember_me).to eq nil
        end
      end

      context 'when remember_me is present' do
        let(:session) do
          FactoryGirl.create :session, remember_me: random_token, user: user
        end

        it 'should hash the remember_me token' do
          expect(session.remember_me).to eq Digest::SHA256.hexdigest(random_token)
        end
      end
    end
  end
end
