class EmailProcessor

  def initialize(email)
    @email = email
  end


  def process
    Rails.logger.info "Processing email for #{@email.from[:email]} with #{filenames}"

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

  def attachments
    @_attachments ||= @email.attachments.map do |file|
      attachment_from_file(file)
    end
  end

  def user
    @_user ||= User.find(message.user_id)
  end

  def message
    @_message ||= InboundMessage.new(
      from_name:  @email.from[:name],
      from_email: @email.from[:email],
      email:      @email.to.first[:email],
      subject:    @email.subject
    )
  end

  def filenames
    @_filenames ||= @email.attachments.map(&:original_filename).join(', ')
  end

  def attachment_from_file(file)
    file_name = file.path.split('/').last
    InboundAttachment.new(file.original_filename, file.read)
  end

end
