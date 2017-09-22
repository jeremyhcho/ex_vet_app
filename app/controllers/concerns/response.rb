module Response
  def json_response(object, status = :ok, opts = {})
    if should_serialize_list?(object, opts)
      object = object.each_with_object([]) do |obj, building_arr|
        building_arr << serialize(obj, opts[:serializer])
      end
    elsif should_serialize_obj?(object, opts)
      object = serialize(object, opts[:serializer])
    end

    render json: object, status: status
  end

  def serialize(object, serializer)
    serializer = serializer ? serializer : "#{object.class.to_s.pluralize}::ShowSerializer".constantize

    serializer
      .new(object)
      .serializable_hash
  end

  def should_serialize_list?(object, opts)
    object.is_a?(ActiveRecord::Relation) ||
      (object.is_a?(Array) && opts[:serializer].present?)
  end

  def should_serialize_obj?(object, opts)
    object.is_a? ActiveRecord::Base ||
      (object.is_a?(Hash) && opts[:serializer].present)
  end
end
