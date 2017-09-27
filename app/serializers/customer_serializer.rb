# == Schema Information
#
# Table name: customers
#
#  id           :integer          not null, primary key
#  first_name   :string           not null
#  last_name    :string           not null
#  company_name :string
#  address      :string
#  email        :string
#  phone_number :string
#  company_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CustomerSerializer < BaseSerializer
  attributes :id,
             :first_name,
             :last_name,
             :address,
             :email,
             :company_name,
             :phone_number
end
