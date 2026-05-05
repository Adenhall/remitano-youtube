require_relative "../system/application_system_test_case"

class VideoFeedTest < ApplicationSystemTestCase
  test "home page auto-refreshes video list when another user shares a video" do
    sign_in_as users(:one)
    visit root_path

    assert_no_text "Auto Refresh Test Video"

    video = users(:two).videos.create!(
      title: "Auto Refresh Test Video",
      youtube_id: "dQw4w9WgXcQ",
      youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    )
    ActionCable.server.broadcast("notifications", {
      title: video.title,
      shared_by: users(:two).email_address
    })

    within("main") do
      assert_text "Auto Refresh Test Video", wait: 5
    end
  end
end
