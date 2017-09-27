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

class Product < ActiveRecord::Base
  validates_presence_of :title

  belongs_to :company
  has_many :options, class_name: 'Products::Option', dependent: :destroy
  has_many :variants, class_name: 'Products::Variant', dependent: :destroy

  monetize :price_cents

  accepts_nested_attributes_for :options
end
