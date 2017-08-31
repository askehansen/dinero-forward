# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/upload_complete
  def upload_complete
    UserMailer.upload_complete
  end

  def done
    UserMailer.done(Purchase.last.message)
  end

  def received
    UserMailer.received(Purchase.last.message)
  end

end
