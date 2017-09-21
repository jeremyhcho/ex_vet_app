class Company < ActiveRecord::Base
  validates_presence_of :name

  has_many :appointments
  has_many :locations

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
end
