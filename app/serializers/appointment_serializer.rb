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

class AppointmentSerializer < BaseSerializer
  attributes :id,
             :from,
             :to,
             :title,
             :description

  belongs_to :creator, serializer: UserSerializer

  def from
    object.from.to_s
  end

  def to
    object.to.to_s
  end
end
