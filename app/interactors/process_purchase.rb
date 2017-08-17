class ProcessPurchase
  include Interactor

  def call
    context.purchase.processing!
    upload = UploadPurchase.call file: context.purchase.file, credentials: context.purchase.user, note: context.purchase.message.subject

    if upload.success?
      context.purchase.processed!
      UserMailer.upload_complete(email: context.purchase.message.from_email, name: context.purchase.message.from_name, filename: context.purchase.filename).deliver_later
    else
      context.purchase.failed!
      UserMailer.upload_failed(email: context.purchase.message.from_email, name: context.purchase.message.from_name, filename: context.purchase.filename, error: upload.error).deliver_later
    end
  end
end
