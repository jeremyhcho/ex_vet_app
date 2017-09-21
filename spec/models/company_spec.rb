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
  context 'validations' do
    it { should validate_presence_of :name }
  end

  context 'associations' do
    it { should belong_to :owner }
    it { should have_many :appointments }
    it { should have_many :locations }
  end
end
