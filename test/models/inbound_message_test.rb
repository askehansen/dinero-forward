require 'test_helper'

class InboundMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'it has data' do
    msg = InboundMessage.new from_name: 'aske', from_email: 'aske@deeco.dk', email: 'unique_id@mail.com', subject: 'hello'

    assert_equal 'aske', msg.from_name
    assert_equal 'aske@deeco.dk', msg.from_email
    assert_equal 'unique_id@mail.com', msg.email
    assert_equal 'hello', msg.subject
  end

  test 'it has user id' do
    msg = InboundMessage.new email: 'unique_id@email.com'

    assert_equal 'unique_id', msg.user_id
  end
end
