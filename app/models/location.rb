# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string
#  country    :string
#  state      :string
#  city       :string
#  address    :string
#  zip        :string
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Location < ActiveRecord::Base
  belongs_to :company
end
