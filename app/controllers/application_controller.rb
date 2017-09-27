class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include ActionController::Cookies
  include Response
  include ExceptionHandler
  include SessionHelper

  before_action :authorize_request, :authorize_company

  private

  def authorize_request
    return true if Rails.env.test?
    return if valid_session?

    current_session&.destroy!
    session.clear
    cookies.delete :remember_me

    raise ExceptionHandler::AuthenticationError, 'Session invalid'
  end

  def authorize_company
    @company = Company.find(params[:company_id])
    authorize! :manage, @company
  end
end
