class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include SessionHelper

  before_action :authorize_request

  private

  def authorize_request
    raise ExceptionHandler::AuthenticationError, 'Token invalid' unless current_session
  end
end
