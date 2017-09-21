module Response
  def json_response(object, status = :ok, opts = {})
    if opts[:each_serializer]
      object = object.each_with_object([]) do |obj, building_arr|
        building_arr << opts[:each_serializer].new(obj).serializable_hash
      end
    elsif opts[:serializer]
      object = opts[:serializer].new(object).serializable_hash
    end

    render json: object, status: status
  end
end
