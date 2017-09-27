# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Company, type: :model do
  subject { described_class.new }

  let(:user) do
    FactoryGirl.create :user
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end

  context 'associations' do
    it { should belong_to :owner }
    it { should have_many :appointments }
    it { should have_many :locations }
    it { should have_many :access_levels }
    it { should have_many(:users).through(:access_levels) }
  end

  context 'instance methods' do
    context '#create_access_level' do
      it 'should create an access_level' do
        expect { subject.send(:create_access_level).to change { AccessLevel.count }.by(1) }
      end
    end
  end
end
