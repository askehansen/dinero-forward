class ProcessEmail
  include Interactor

  def call
    message = generate_message(context.message)
    attachments = generate_attachments(context.message['attachments'])

    begin
      user = User.find(message.user_id)
    rescue ActiveRecord::RecordNotFound
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

    def generate_message(data)
      InboundMessage.new(
        from_name:  data['from_name'],
        from_email: data['from_email'],
        email:      data['email'],
        subject:    data['subject']
      )
    end

    def generate_attachments(data)
      data.to_a.map do |filename, attachment|
        decoder = InboundAttachment::Base64Decoder.new if attachment['base64']

        InboundAttachment.new(
          filename: filename,
          content:  attachment['content'],
          decoder:  decoder
        )
      end
    end
end
