class EmailProcessor

  def initialize(email)
    @email = email
  end


  def process
    return false if to_email.nil?
    return false if to_email[:email] == 'noreply@dinero-forward.dk'

    Rails.logger.info "Processing email for #{@email.from[:email]} with #{filenames}"

    if @email.from[:email] == 'forwarding-noreply@google.com'
      return UserMailer.gmail_forwarding(message).deliver_later
    end

    if purchases.any?
      purchases.each do |purchase|
        ProcessPurchaseJob.perform_later(purchase)
      end
    elsif user.can.create_pdf? && message.raw_html.present?
      CreatePdfJob.perform_later(message)
    else
      UserMailer.no_attachments(message).deliver_later
    end

  rescue Mail::Field::ParseError => e
    UserMailer.error(@email.from[:email], e.message).deliver_later
  rescue Exception => e
    Errbase.report(e)
    UserMailer.error(@email.from[:email], e.message).deliver_later
  end

  private

  def to_email
    @email.to.select do |email|
      /.+@dinero-forward\.dk/ === email[:email]
    end.first
  end

  def text_encoding
    @email.charsets[:text]
  end

  def raw_html
    @email.raw_html&.encode('utf-8', text_encoding)
  end

  def purchases
    @_purchases ||= @email.attachments.map do |attachment|
      purchase = Purchase.create!(
        filename: attachment.original_filename,
        message: message,
        status: :unprocessed
      )

      purchase.file_v2.attach(attachment)

      purchase
    end
  end

  def user
    @_user ||= User.find(user_id)
  end

  def user_id
    /(?<id>.+)@/.match(to_email[:email])[:id]
  end

  def message
    @_message ||= Message.create!(
      from_name:  @email.from[:name],
      from_email: @email.from[:email],
      email:      to_email[:email],
      subject:    @email.subject,
      body:       @email.body,
      user:       user,
      status:     :unprocessed,
      raw_html:   raw_html
    )
  end

  def filenames
    @_filenames ||= @email.attachments.map(&:original_filename).join(', ')
  end

end
