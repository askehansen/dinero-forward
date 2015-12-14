class UserMailer < ApplicationMailer

  def upload_complete(email:, name:, filename:)
    @name = name
    @filename = filename

    mail to: "#{name} <#{email}>", subject: 'Bilag modtaget'
  end

  def upload_failed(email:, name:, filename:)
    @name = name
    @filename = filename

    mail to: "#{name} <#{email}>", subject: 'Bilag blev ikke uploadet'
  end

end
