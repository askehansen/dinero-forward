class UserMailer < ApplicationMailer

  def upload_complete(email:, name:, filename:)
    @name = name
    @filename = filename
    @date = DateTime.now.strftime '%d/%m/%Y'

    mail to: "#{name} <#{email}>", subject: 'Bilag modtaget'
  end

  def upload_failed(email:, name:, filename:, error:)
    @name = name
    @filename = filename
    @error = error

    mail to: "#{name} <#{email}>", subject: 'Bilag blev ikke uploadet'
  end

  def error(email, error)
    @error = error
    mail to: email, subject: 'Uventet fejl'
  end

end
