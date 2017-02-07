class CreatePurchaseJob < ActiveJob::Base
  queue_as :purchases

  def perform(opts={})
    file = Storage.new.open_file(opts[:file_key])

    upload = UploadPurchase.call file: file, credentials: opts[:user], note: opts[:subject]

    if upload.success?
      UserMailer.upload_complete(email: opts[:from_email], name: opts[:from_name], filename: opts[:filename]).deliver_later
    else
      UserMailer.upload_failed(email: opts[:from_email], name: opts[:from_name], filename: opts[:filename]).deliver_later
    end
  end
end
