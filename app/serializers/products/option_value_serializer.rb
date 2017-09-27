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
  class OptionValueSerializer < BaseSerializer
    attributes :id,
               :option_value
  end
end
