class InboundJob < ActiveJob::Base
  queue_as :inbound

  def perform(msg)
    ProcessEmail.call msg: msg
  end
end
