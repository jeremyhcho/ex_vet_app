module RequestHelper
  def json_response
    JSON.parse(response.body).symbolize_keys
  end
end
