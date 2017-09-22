# == Schema Information
#
# Table name: appointments
#
#  id          :integer          not null, primary key
#  from        :datetime         not null
#  to          :datetime         not null
#  title       :string           not null
#  description :text
#  location_id :integer
#  creator_id  :integer
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Appointment < ActiveRecord::Base
  validates_presence_of :from, :to, :title

  belongs_to :location
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  belongs_to :company
end
