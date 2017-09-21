# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string
#  country    :string
#  state      :string
#  city       :string
#  address    :string
#  zip        :string
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Location, type: :model do
  context 'associations' do
    it { should belong_to :company }
  end
end
