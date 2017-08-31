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
      message.processed!
      UserMailer.done(message).deliver_later
    end
  end

  def message
    context.purchase.message
  end
end
