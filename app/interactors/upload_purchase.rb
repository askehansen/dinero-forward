class UploadPurchase
  include Interactor

  def call
    client = Dinero.new organization_id: context.organization_id, api_key: context.api_key
    client.authorize!

    begin
      file_id = client.create_file context.file
      sleep 1
      context.purchase = client.create_purchase file_id: file_id, notes: context.note
    rescue => e
      Errbase.report(e)
      context.failed!
    end
  end
end
