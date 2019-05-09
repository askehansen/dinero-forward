class PurchasesMailbox < ApplicationMailbox

  def process
    return false if recipient.nil?

    Rails.logger.info "Processing email for #{mail.from_address.address} with #{filenames}"

    if mail.from_address.address == 'forwarding-noreply@google.com'
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
    UserMailer.error(mail.from_address.address, e.message).deliver_later
  rescue Exception => e
    Errbase.report(e)
    UserMailer.error(mail.from_address.address, e.message).deliver_later
  end

  private



  def text_encoding
    @email.charsets[:text]
  end

  def raw_html
    if mail.body
      mail.body.decoded
    end
  end

  def body
    if mail.body
      mail.body.decoded
    else
      mail.text_part.decoded
    end
  end

  def recipient
    recipients.select do |recipient|
      /.+@in.dinero-forward\.dk/ === recipient.address
    end.first
  end

  def recipients
    (mail.to_addresses + mail.x_forwarded_to_addresses).flatten
  end

  def

  def purchases
    @_purchases ||= mail.attachments.map do |attachment|
      purchase = Purchase.create!(
        filename: attachment.filename,
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
    /(?<id>.+)@/.match(recipient.address)[:id]
  end

  def message
    @_message ||= Message.create!(
      from_name:  mail.from_address.name,
      from_email: mail.from_address.address,
      email:      recipient.address,
      subject:    mail.subject,
      body:       body,
      user:       user,
      status:     :unprocessed,
      raw_html:   raw_html
    )
  end

  def filenames
    @_filenames ||= mail.attachments.map(&:filename).join(', ')
  end

end
