module Mail
  class Message
    def x_forwarded_to_addresses
      Array(header[:x_forwarded_to]).collect { |header| Mail::Address.new header.to_s }
    end
  end
end
