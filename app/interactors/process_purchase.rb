class ProcessPurchase
  include Interactor

  def call
    context.purchase.processing!
    upload = UploadPurchase.call file: context.purchase.file, credentials: context.purchase.user, note: context.purchase.message.subject

    if upload.success?
      context.purchase.processed!
    else
      context.purchase.failed!
    end

    notify_user if message.unprocessed? && message.purchases.unprocessed.empty? && message.purchases.processing.empty?
  end

  private

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
