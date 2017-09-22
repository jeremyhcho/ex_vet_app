module Response
  def json_response(object, status = :ok, opts = {})
    if object.is_a? ActiveRecord::Relation
      object = object.each_with_object([]) do |obj, building_arr|
        building_arr << serialize(obj)
      end
    elsif object.is_a? ActiveRecord::Base
      object = serialize(object)
    end

    render json: object, status: status
  end

  def serialize(object)
    "#{object.class.to_s.pluralize}::ShowSerializer"
      .constantize
      .new(object)
      .serializable_hash
  end
end
