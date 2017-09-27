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

class ProductSerializer < BaseSerializer
  attributes :id,
             :title,
             :description,
             :image_url,
             :price,
             :options_attributes

  has_many :variants, serializer: Products::VariantSerializer

  def price
    object.price.format(symbol: true)
  end

  def options_attributes
    object.options.map do |option|
      Products::OptionSerializer.new(option).serializable_hash
    end
  end
end
