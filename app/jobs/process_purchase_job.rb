class ProcessPurchaseJob < ApplicationJob
  queue_as :purchases

  def perform(purchase)
    process!(purchase) if purchase.unprocessed?
  end

  private

  def process!(purchase)
    purchase.processing!
    upload = UploadPurchase.call file: purchase.file, credentials: purchase.user, note: purchase.subject

    if upload.success?
      purchase.processed!
      UserMailer.upload_complete(email: purchase.from_email, name: purchase.from_name, filename: purchase.filename).deliver_later
    else
      purchase.failed!
      UserMailer.upload_failed(email: purchase.from_email, name: purchase.from_name, filename: purchase.filename, error: upload.error).deliver_later
    end
  end

end
