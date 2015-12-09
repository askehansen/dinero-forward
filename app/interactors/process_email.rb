class ProcessEmail
  include Interactor

  def call
    email = context.msg['from_email']
    name = context.msg['from_name']
    email = context.msg['email']
    attachments = context.msg['attachments'].to_a

    /(?<id>.+)@/ =~ email
    user = User.find id

    attachments.each do |name, attachment|
      file = Tempfile.new name
      file.write attachment['content']

      UploadPurchase.call file: file, organization_id: user.organization_id, api_key: user.api_key

      UserMailer.upload_complete(email: email, name: name, filename: filename).deliver_now
    end
  end
end
