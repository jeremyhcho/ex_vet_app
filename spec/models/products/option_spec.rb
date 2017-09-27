# == Schema Information
#
# Table name: products_options
#
#  id          :integer          not null, primary key
#  option_name :string
#  product_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Products::Option, type: :model do
  context 'validations' do
    it { should validate_presence_of :option_name }
  end

  context 'associations' do
    it { should belong_to :product }
  end

  context 'matchers' do
    it { should accept_nested_attributes_for :option_values }
  end
end
