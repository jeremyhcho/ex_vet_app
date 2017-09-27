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
  class Option < ActiveRecord::Base
    validates_presence_of :option_name

    belongs_to :product
    has_many :option_values, dependent: :destroy

    accepts_nested_attributes_for :option_values
  end
end
