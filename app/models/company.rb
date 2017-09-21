# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Company < ActiveRecord::Base
  validates_presence_of :name

  has_many :appointments
  has_many :locations

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
end
