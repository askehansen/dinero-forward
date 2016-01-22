class EmailProcessor

  def initialize(email)
    @email = email
  end

  def process
    Rails.logger.info "Processing email for #{@email.from[:email]} with #{filenames}"

    attachments.each do |attachment|
      create_job(attachment)
    end
  end

  private

    def attachments
      @email.attachments.each do |file|
        attachment = InboundAttachment.new(filename(file), file.read)
        attachment.save!
        attachment
      end
    end

    def create_job(attachment)
      CreatePurchaseJob.perform_later(
        file_key:   attachment.key,
        filename:   attachment.filename,
        from_email: @email.from[:email],
        from_name:  @email.from[:name],
        subject:    @email.subject,
        user:       user
      )
    end

    def user
      @user ||= User.find(@email.to[:token])
    end

    def filenames
      @email.attachments.map do |file|
        filename(file)
      end
    end

    def filename(file)
      file.path.split('/').last
    end

end
