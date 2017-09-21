class Appointment < ActiveRecord::Base
  validates_presence_of :from, :to, :title

  belongs_to :location
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  belongs_to :company
end
