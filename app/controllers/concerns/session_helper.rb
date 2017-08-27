module SessionHelper
  def login!
    new_session = @user.sessions.create!
    session[:session_token] = new_session.token
  end

  def current_user
    return if session[:session_token].nil?
    @current_user ||= current_session.user
  end

  def logged_in?
    current_user.present?
  end

  def logout!
    current_session.destroy!
    session[:session_token] = nil
    @current_user = nil
  end

  def current_session
    @current_session ||= Session
                         .includes(:user)
                         .find_by(token: session[:session_token])
  end
end
