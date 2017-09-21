module Appointments
  class ShowSerializer < BaseSerializer
    attributes :id,
               :from,
               :to,
               :title,
               :description

    belongs_to :creator, serializer: Users::ShowSerializer

    def from
      object.from.to_s
    end

    def to
      object.to.to_s
    end
  end
end
