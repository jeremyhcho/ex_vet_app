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

  has_many :appointments, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :companies_users, dependent: :destroy
  has_many :users, through: :companies_users

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
end
