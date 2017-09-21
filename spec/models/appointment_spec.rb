# == Schema Information
#
# Table name: appointments
#
#  id          :integer          not null, primary key
#  from        :datetime         not null
#  to          :datetime         not null
#  title       :string           not null
#  description :text
#  location_id :integer
#  creator_id  :integer
#  business_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Appointment, type: :model do
  context 'validations' do
    it { should validate_presence_of :from }
    it { should validate_presence_of :to }
    it { should validate_presence_of :title }
  end

  context 'associations' do
    it { should belong_to :location }
    it { should belong_to :creator }
    it { should belong_to :company }
  end
end
