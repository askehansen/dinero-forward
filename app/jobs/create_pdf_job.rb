class CreatePdfJob < ApplicationJob
  queue_as :purchases

  def perform(message)
    pdf = WickedPdf.new.pdf_from_string(message.raw_html, encoding: 'utf-8')

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

    purchase.file_v2.attach(io: StringIO.new(pdf), filename: filename)

    ProcessPurchaseJob.perform_later(purchase)
  end

end
