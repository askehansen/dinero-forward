class UploadPurchase
  include Interactor

  def call
    client = Dinero.new organization_id: context.organization_id, api_key: context.api_key
    client.authorize!
    file_id = client.create_file context.file
    client.create_purchase file_id: file_id
  end
end
