class InboundMessage
  attr_accessor :from_email, :from_name, :email, :subject, :attachments, :user

  def initialize(opts={})
    @from_email  = opts[:from_email]
    @from_name   = opts[:from_name]
    @email       = opts[:email]
    @subject     = opts[:subject]
  end

  def user_id
    /(?<id>.+)@/.match(@email)[:id]
  end

end
