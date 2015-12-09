class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.upload_complete.subject
  #
  def upload_complete(email:, name:, filename:)
    @name = name
    @filename = filename

    mail to: "<#{name}> #{email}", subject: 'Bilag modtaget'
  end
end
