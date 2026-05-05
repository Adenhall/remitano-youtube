require "test_helper"

class NotificationsChannelTest < ActionCable::Channel::TestCase
  test "subscribes and streams for the current user" do
    user = users(:one)
    stub_connection current_user: user
    subscribe
    assert subscription.confirmed?
    assert_has_stream_for user
  end
end
