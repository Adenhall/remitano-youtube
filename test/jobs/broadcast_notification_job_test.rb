require "test_helper"

class BroadcastNotificationJobTest < ActiveJob::TestCase
  include ActionCable::TestHelper
  test "broadcasts video title and sharer to notifications channel" do
    video = videos(:one)
    assert_broadcast_on("notifications", {
      title: video.title,
      shared_by: video.user.email_address
    }) do
      BroadcastNotificationJob.perform_now(video)
    end
  end
end
