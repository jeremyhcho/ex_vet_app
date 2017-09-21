module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end

  included do
    rescue_from AuthenticationError do |e|
      json_response({ messages: { unauthorized: e.message } }, :unauthorized)
    end

    rescue_from BadRequest do |e|
      json_response({ messages: { bad_request: e.message } }, :bad_request)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ messages: e.record.errors.messages }, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ messages: { not_found: e.message } }, :not_found)
    end
  end
end
