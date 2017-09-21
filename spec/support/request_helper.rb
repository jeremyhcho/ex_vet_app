module RequestHelper
  def json_response
    parsed_json = JSON.parse(response.body)

    if parsed_json.is_a? Array
      parsed_json.map(&:deep_symbolize_keys)
    else
      parsed_json.deep_symbolize_keys
    end
  end
end
