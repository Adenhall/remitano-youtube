require "test_helper"

class NotificationsChannelTest < ActionCable::Channel::TestCase
  test "subscribes and streams from notifications" do
    stub_connection current_user: users(:one)
    subscribe
    assert subscription.confirmed?
    assert_has_stream "notifications"
  end
end
