class ProcessEmail
  include Interactor

  def call
    from_email = context.msg['from_email']
    from_name = context.msg['from_name']
    email = context.msg['email']
    subject = context.msg['subject']
    attachments = context.msg['attachments'].to_a
    /(?<id>.+)@/ =~ email # sets id

    Rails.logger.info "Processing email for #{from_email}"

    begin
      user = User.find id
    rescue ActiveRecord::RecordNotFound
      Rails.logger.info "User not found for #{from_email}"
      context.error = 'User not found'
      context.fail!
    end

    attachments.each do |filename, attachment|
      ext = File.extname(filename)
      tmpfile = Tempfile.new [filename, ext], encoding: 'ascii-8bit'

      if attachment['base64']
        tmpfile.write Base64.decode64(attachment['content'])
      else
        tmpfile.write attachment['content']
      end


      # weird behaviour where dinero wont accept the tmpfile
      tmpfile.close
      file = File.open tmpfile.path

      Rails.logger.info "Uploading purchase for #{from_email}"

      upload = UploadPurchase.call file: file, organization_id: user.organization_id, api_key: user.api_key, note: subject

      if upload.success?
        Rails.logger.info "Successfully uploaded purchase for #{from_email}"
        UserMailer.upload_complete(email: from_email, name: from_name, filename: filename).deliver_later
      else
        Rails.logger.info "Failed uploading purchase for #{from_email}"
        Usermailer.upload_failed(email: from_email, name: from_name, filename: filename).deliver_later
      end
    end
  end

end
