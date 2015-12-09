class ProcessEmail
  include Interactor

  def call
    from_email = context.msg['from_email']
    from_name = context.msg['from_name']
    email = context.msg['email']
    subject = context.msg['subject']
    attachments = context.msg['attachments'].to_a

    /(?<id>.+)@/ =~ email
    user = User.find id

    attachments.each do |filename, attachment|
      ext = MIME::Types[attachment['type']].first.extensions.first
      tmpfile = Tempfile.new [filename, ".#{ext}"], encoding: 'ascii-8bit'

      if attachment['base64']
        tmpfile.write Base64.decode64(attachment['content'])
      else
        tmpfile.write attachment['content']
      end


      # weird behaviour where dinero wont accept the tmpfile
      tmpfile.close
      file = File.open tmpfile.path

      UploadPurchase.call file: file, organization_id: user.organization_id, api_key: user.api_key, note: subject
      UserMailer.upload_complete(email: from_email, name: from_name, filename: filename).deliver_now
    end
  end
end
