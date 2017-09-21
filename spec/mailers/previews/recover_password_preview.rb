# Preview all emails at http://localhost:3000/rails/mailers/recover_password
class RecoverPasswordPreview < ActionMailer::Preview
  def send_preview
    RecoverPasswordMailer.send_recover_password(User.first)
  end
end
