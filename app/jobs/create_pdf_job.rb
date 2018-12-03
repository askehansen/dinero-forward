class CreatePdfJob < ApplicationJob
  queue_as :purchases

  def perform(message)
    pdf = WickedPdf.new.pdf_from_string(message.raw_html)

    filename = message.subject.presence || 'faktura'
    filename = "#{filename}.pdf"

    file_key = [SecureRandom.uuid, filename].join('/')

    storage = Storage.new
    storage.write_file(file_key, pdf)

    purchase = Purchase.create!(
      file_key: file_key,
      filename: filename,
      message: message,
      status: :unprocessed
    )

    ProcessPurchaseJob.perform_later(purchase)
  end

end
