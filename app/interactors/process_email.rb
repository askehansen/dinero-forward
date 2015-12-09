class ProcessEmail
  include Interactor

  def call
    email = context.msg['from_email']
    name = context.msg['from_name']
    email = context.msg['email']
    attachments = context.msg['attachments'].to_a

    /(?<id>.+)@/ =~ email
    user = User.find id

    attachments.each do |attachment|
      file = Tempfile.new
      file.write attachment['content']

      UploadPurchase file: file, organization_id: user.organization_id, api_key: user.api_key
    end
  end
end
