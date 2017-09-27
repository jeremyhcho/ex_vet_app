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

require 'rails_helper'

describe AccessLevel, type: :model do
  context 'associations' do
    it { should belong_to :company }
    it { should belong_to :user }
  end
end
