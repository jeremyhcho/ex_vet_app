class RecoverPasswordMailer < ActionMailer::Base
  default from: 'hyungchulcho93@gmail.com'
  layout 'mailer'

  def send_recover_password(user)
    @user = user
    mail(to: @user.email, subject: 'Test 123')
  end
end
