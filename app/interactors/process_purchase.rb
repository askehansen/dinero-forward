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

    notify_user
  end

  private

  def notify_user
    if !message.purchases.unprocessed.any? && message.unprocessed?
      begin
        message.processed!
        UserMailer.done(message).deliver_later
      rescue ActiveRecord::StaleObjectError => e
        # optimistic locking to prevent duplicated emails
      end
    end
  end

  def message
    context.purchase.message
  end
end
