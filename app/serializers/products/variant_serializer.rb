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
  class VariantSerializer < BaseSerializer
    attributes :variant_values

    attribute :price, if: -> { object.price > 0 }

    def price
      object.price.format(symbol: true)
    end

    def variant_values
      object.variant_values.map do |variant_value|
        Products::VariantValueSerializer.new(variant_value).serializable_hash
      end
    end
  end
end
