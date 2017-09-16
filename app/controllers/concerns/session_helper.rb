module SessionHelper
  def login!
    session[:session_token] = new_session.token
    session[:expires_at] = Time.now + 1.week
    cookies[:authorized] = { value: true, expires: 1.week.from_now }
    cookies[:remember_me] = { value: params[:remember_me], expires: 1.week.from_now }
    new_session.save!
  end

  def current_user
    return if session[:session_token].nil?
    @current_user ||= current_session&.user
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
    return if session[:session_token].nil?
    @current_session ||= Session.includes(:user).find_by(session_params)
  end

  def valid_session?
    # Check for existing session and session's `expires_at` time.
    return false if session_expired?

    # If above is true and current_session is toggled for `remember_me`, return true
    return true if valid_remember_me?

    # If `remember_me` not set, check session's updated_at time for expiry
    return false if session_inactive?

    # Else, touch the current_session and return true
    current_session.touch
  end

  def session_expired?
    !current_session || session[:expires_at].to_time < Time.current
  end

  def valid_remember_me?
    current_session.remember_me.present? &&
      Digest::SHA256.hexdigest(cookies[:remember_me]) == current_session.remember_me
  end

  def session_inactive?
    current_session.updated_at + 30.minutes < Time.now
  end

  private

  def session_params
    {
      token: Digest::SHA256.hexdigest(session[:session_token]),
      remember_me: cookies[:remember_me].present? ? Digest::SHA256.hexdigest(cookies[:remember_me]) : nil
    }
  end

  def new_session
    @new_session ||= @user.sessions.new(remember_me: params[:remember_me])
  end
end
