module Locations
  class ShowSerializer < BaseSerializer
    attributes :id,
               :name,
               :country,
               :state,
               :city,
               :address,
               :zip
  end
end
