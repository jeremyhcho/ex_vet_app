# == Schema Information
#
# Table name: products_variant_values
#
#  id              :integer          not null, primary key
#  variant_id      :integer
#  option_value_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe Products::VariantValue, type: :model do
  context 'associations' do
    it { should belong_to :variant }
    it { should belong_to :option_value }
  end
end
