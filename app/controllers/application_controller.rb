class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Response
  include ExceptionHandler
  include SessionHelper

  before_action :authorize_request

  private

  def authorize_request
    return true if Rails.env.test?
    return if valid_session?

    current_session&.destroy!
    session.clear
    cookies.delete :remember_me

    raise ExceptionHandler::AuthenticationError, 'Session invalid'
  end
end
