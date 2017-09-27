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

module Products
  class Variant < ActiveRecord::Base
    belongs_to :product
    has_many :variant_values, dependent: :destroy

    monetize :price_cents
  end
end
