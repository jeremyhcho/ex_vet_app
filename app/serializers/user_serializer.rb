# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  profile_picture :string
#  status          :string
#  phone_number    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UserSerializer < BaseSerializer
  attributes :id,
             :email,
             :first_name,
             :last_name,
             :profile_picture,
             :status,
             :phone_number
end
