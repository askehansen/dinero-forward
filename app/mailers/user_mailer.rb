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

  def received(message)
    @name = message.from_name
    @files = message.purchases.pluck(:filename)

    mail to: "#{message.from_name} <#{message.from_email}>", subject: 'Bilag modtaget'
  end

  def done(message)
    @name = message.from_name
    @date = DateTime.now.strftime '%d/%m/%Y'

    @processed = message.purchases.processed.pluck(:filename)
    @failed = message.purchases.failed.pluck(:filename)

    mail to: "#{message.from_name} <#{message.from_email}>", subject: 'Bilag uploadet'
  end

  def error(email, error)
    @error = error
    mail to: email, subject: 'Uventet fejl'
  end

end
