class UploadPurchase
  include Interactor

  def call
    client = Dinero.new organization_id: context.credentials.organization_id, api_key: context.credentials.api_key

    begin
      client.authorize!

      file_id = client.create_file context.file
      sleep 1
      context.purchase = client.create_purchase file_id: file_id, notes: context.note

      if context.purchase.failed?
        context.fail!
        context.error = context.response
      end

    rescue RestClient::UnsupportedMediaType => e
      context.error = e.message
      context.fail!
    rescue => e
      Errbase.report(e)
      context.error = e.message
      context.fail!
    end
  end
end
