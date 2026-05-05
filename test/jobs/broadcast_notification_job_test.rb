require "test_helper"

class BroadcastNotificationJobTest < ActiveJob::TestCase
  include ActionCable::TestHelper

  test "broadcasts to every user except the sharer" do
    video = videos(:one)
    sharer = video.user
    recipient = users(:two)
    payload = { title: video.title, shared_by: sharer.email_address }

    assert_broadcast_on(NotificationsChannel.broadcasting_for(recipient), payload) do
      BroadcastNotificationJob.perform_now(video)
    end
  end

  test "does not broadcast to the sharer" do
    video = videos(:one)
    sharer = video.user

    assert_no_broadcasts(NotificationsChannel.broadcasting_for(sharer)) do
      BroadcastNotificationJob.perform_now(video)
    end
  end
end
