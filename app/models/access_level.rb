# == Schema Information
#
# Table name: access_levels
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  company_id :integer
#  is_admin   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AccessLevel < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
end
