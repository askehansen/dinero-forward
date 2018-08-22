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

  def no_attachments
    message = Message.new(
      email: "123@dinero-forward.dk",
      from_name: "Aske hansen",
      from_email: "aske@deeco.dk",
      created_at: DateTime.now,
      subject: "Kvittering",
      body: "Hej aske\n\n---\nMed venlig hilsen\n\nAske Hansen\nwww.deeco.dk\n+45 31 60 03 03"
    )
    UserMailer.no_attachments(message)
  end

end
