# == Schema Information
#
# Table name: products_variants
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  price_cents :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Products::Variant, type: :model do
  context 'associations' do
    it { should belong_to :product }
    it { should have_many :variant_values }
  end
end
