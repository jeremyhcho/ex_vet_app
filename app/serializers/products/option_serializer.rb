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

module Products
  class OptionSerializer < BaseSerializer
    attributes :id,
               :option_name,
               :option_values_attributes

    def option_values_attributes
      object.option_values.map do |value|
        Products::OptionValueSerializer.new(value).serializable_hash
      end
    end
  end
end
