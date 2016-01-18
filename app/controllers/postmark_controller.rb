class PostmarkController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    email = Postmark::Mitt.new(request.body.read)

    filenames = email.attachments.map(&:file_name).join(', ')
    Rails.logger.info "Processing email for #{email.from_email} with #{filenames}"

    message = InboundMessage.new(
      from_name:  email.from_name,
      from_email: email.from_email,
      email:      email.to_email,
      subject:    email.subject
    )

    user = User.find(message.user_id)

    attachments = email.attachments.map do |attachment|
      InboundAttachment.new(attachment.file_name, attachment.read.read)
    end

    attachments.each do |attachment|
      attachment.save!

      CreatePurchaseJob.perform_later(
        file_key:   attachment.key,
        filename:   attachment.filename,
        from_email: message.from_email,
        from_name:  message.from_name,
        subject:    message.subject,
        user:       user
      )
    end

    head :ok
  end

end
