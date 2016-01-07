class InboundAttachment
  attr_accessor :filename

  def initialize(filename, content, decoder=nil)
    @filename = filename
    @content = content
    @decoder = decoder || DefaultDecoder.new
    @uuid = SecureRandom.uuid
  end

  def content
    @decoder.decode(@content)
  end

  def key
    [@uuid, @filename].join('/')
  end

  def save!
    Storage.new.write_file(key, @content)
  end


  class DefaultDecoder
    def decode(data)
      data
    end
  end

  class Base64Decoder
    def decode(data)
      Base64.decode64(data)
    end
  end

end
