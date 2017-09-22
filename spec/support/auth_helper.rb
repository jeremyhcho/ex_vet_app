module AuthHelper
  def sign_in_as!(user)
    if user.password.nil?
      raise ArgumentError, 'Must supply password field to factory in order to sign in properly'
    end

    post '/api/v1/login', params: {
      user: {
        email: user.email, password: user.password
      }
    }
  end
end
