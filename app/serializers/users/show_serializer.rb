module Users
  class ShowSerializer < BaseSerializer
    attributes :id,
               :email,
               :first_name,
               :last_name,
               :profile_picture,
               :status,
               :phone_number
  end
end
