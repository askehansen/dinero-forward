require 'test_helper'

class InboundAttachmentTest < ActiveSupport::TestCase

  test 'it has data' do
    attachment = InboundAttachment.new 'file.txt', 'hello world'

    assert_equal 'file.txt', attachment.filename
    assert_equal 'hello world', attachment.content
  end

  test 'it has a key' do
    attachment = InboundAttachment.new 'file.txt', 'hello world'

    assert_match /(.*)\/file.txt/, attachment.key
  end

  test 'it can decode base64' do
    content = Base64.encode64('hello world')
    attachment = InboundAttachment.new 'file.txt', content, InboundAttachment::Base64Decoder.new

    assert_equal 'hello world', attachment.content
  end

end
