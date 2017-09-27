# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text
#  image_url   :string
#  company_id  :integer
#  price_cents :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Product, type: :model do
  context 'validations' do
    it { should validate_presence_of :title }
  end

  context 'associations' do
    it { should belong_to :company }
    it { should have_many :options }
  end

  context 'matchers' do
    it { should accept_nested_attributes_for :options }
  end
end
