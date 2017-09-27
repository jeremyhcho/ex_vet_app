# == Schema Information
#
# Table name: products_option_values
#
#  id           :integer          not null, primary key
#  option_value :string           not null
#  option_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe Products::OptionValue, type: :model do
  context 'validations' do
    it { should validate_presence_of :option_value }
  end

  context 'associations' do
    it { should belong_to :option }
  end
end
