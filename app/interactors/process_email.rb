class ProcessEmail
  include Interactor

  def call
    files = attachments.map(&:filename).join(', ')
    Rails.logger.info "Processing email for #{message.from_email} with #{files}"

    begin
      user = User.find(message.user_id)
    rescue ActiveRecord::RecordNotFound => e
      Errbase.report(e)
      context.fail!
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
  end

  private

    def message
      @message ||= InboundMessage.new(
        from_name:  context.message['from_name'],
        from_email: context.message['from_email'],
        email:      context.message['email'],
        subject:    context.message['subject']
      )
    end

    def attachments
      @attachments ||= context.message['attachments'].to_a.map do |filename, attachment|
        decoder = InboundAttachment::Base64Decoder.new if attachment['base64']
        InboundAttachment.new(filename, attachment['content'], decoder)
      end
    end

    def attachments_and_images
      context.message['attachments'].to_a + context.message['images'].to_a
    end
end
