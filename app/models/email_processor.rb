class EmailProcessor

  def initialize(email)
    @email = email
  end


  def process
    Rails.logger.info "Processing email for #{@email.from[:email]} with #{filenames}"

    begin
      purchases.each do |purchase|
        CreatePurchaseJob.perform_later(purchase)
      end
    rescue Exception => e
      UserMailer.error(@email.from[:email], e.message).deliver_later
      raise e
    end

  end

  private

  def attachments
    @_attachments ||= @email.attachments.map do |file|
      attachment_from_file(file)
    end
  end

  def purchases
    @_purchases ||= attachments.map do |attachment|
      attachment.save!

      Purchase.create(
        filename: attachment.filename,
        file_key: attachment.key,
        message: message,
        status: :unprocessed
      )
    end
  end

  def user
    @_user ||= User.find(user_id)
  end

  def user_id
    /(?<id>.+)@/.match(@email.to.first[:email])[:id]
  end

  def message
    @_message ||= Message.create(
      from_name:  @email.from[:name],
      from_email: @email.from[:email],
      email:      @email.to.first[:email],
      subject:    @email.subject,
      user:       user
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
