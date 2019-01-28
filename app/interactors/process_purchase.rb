class ProcessPurchase
  include Interactor

  def call
    context.purchase.processing!

    upload_file if validate_file

    notify_user if message.unprocessed? && message.purchases.unprocessed.empty? && message.purchases.processing.empty?
  end

  private

  def upload_file
    upload = UploadPurchase.call file: context.purchase.file, credentials: context.purchase.user, note: context.purchase.message.subject

    if upload.success?
      context.purchase.processed!
    else
      context.purchase.failed!
    end
  end

  def validate_file
    context.purchase.validate_file!
    true
  rescue Purchase::InvalidFileError => e
    Errbase.report(e)
    context.purchase.failed!
    false
  end

  def notify_user
    begin
      message.processed!
      UserMailer.done(message).deliver_later
    rescue ActiveRecord::StaleObjectError => e
      # optimistic locking to prevent duplicated emails
    end
  end

  def message
    context.purchase.message
  end
end
