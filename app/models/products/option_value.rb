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

module Products
  class OptionValue < ActiveRecord::Base
    validates_presence_of :option_value

    belongs_to :option
    has_many :variant_values, dependent: :destroy

    delegate :product, to: :option

    after_create :create_variants

    private

    def create_variants
      product.reload

      if product.variants.length.zero?
        # This is the first option value being created
        return create_single_variant
      end

      if product.options.length == product.variants[0].variant_values.length
        # Option value is being added onto an option with existing option values
        valid_options = product.options.select { |opt| opt.id != option.id }

        if valid_options.length.zero?
          # New option value is being added, but only one option type exists
          return create_single_variant
        end

        valid_option_values = valid_options.map do |opt|
          opt.option_values.pluck(:id)
        end

        [id].product(*valid_option_values).each do |value_combinations|
          variant = Products::Variant.create(product_id: product.id)

          value_combinations.each do |value_id|
            variant.variant_values.create!(option_value_id: value_id)
          end
        end
      else
        # Option value is being added onto an option as the first value
        product.variants.each do |var|
          var.variant_values.create!(option_value_id: id)
        end
      end
    end

    def create_single_variant
      variant = product.variants.create!
      return variant.variant_values.create!(option_value_id: id)
    end
  end
end
