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

    mail to: "#{message.from_name} <#{message.from_email}>", subject: "Re: #{message.subject}"
  end

  def no_attachments(message)
    @message = message

    mail to: "#{message.from_name} <#{message.from_email}>", subject: "Re: #{@message.subject}"
  end

  def done(message)
    @message = message
    @name = message.from_name
    @date = DateTime.now.strftime '%d/%m/%Y'

    @processed = message.purchases.processed.pluck(:filename)
    @failed = message.purchases.failed.pluck(:filename)

    mail to: "#{message.from_name} <#{message.from_email}>", subject: "Re: #{message.subject}"
  end

  def error(email, error)
    @error = error
    mail to: email, subject: 'Uventet fejl'
  end

  def gmail_forwarding(message)
    @message = message
    email = /(\S+)\z/.match(@message.subject)[1]

    mail to: email, subject: @message.subject
  end

end
