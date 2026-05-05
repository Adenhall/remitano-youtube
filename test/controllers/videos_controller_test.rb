require "test_helper"

class VideosControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "new redirects to root when not logged in" do
    get new_video_path
    assert_redirected_to root_path
  end

  test "new renders share form for authenticated users" do
    sign_in_as(@user)
    get new_video_path
    assert_response :success
    assert_equal "Videos/New", inertia.component
  end

  test "create redirects to root when not logged in" do
    post videos_path, params: { youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    assert_redirected_to root_path
  end

  test "create rejects a non-YouTube URL" do
    sign_in_as(@user)
    post videos_path, params: { youtube_url: "https://vimeo.com/123" }
    assert_redirected_to new_video_path
    assert_match(/valid YouTube URL/, flash[:alert])
  end

  test "create saves video and redirects on success" do
    sign_in_as(@user)
    Video.define_singleton_method(:fetch_title) { |_| "Rick Astley - Never Gonna Give You Up" }
    begin
      assert_difference "Video.count", 1 do
        post videos_path, params: { youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
      end
      assert_redirected_to root_path
      assert_match(/shared/, flash[:notice])
      assert_equal @user.id, Video.last.user_id
      assert_equal "dQw4w9WgXcQ", Video.last.youtube_id
    ensure
      Video.singleton_class.remove_method(:fetch_title)
    end
  end

  test "create redirects back with alert when title fetch fails" do
    sign_in_as(@user)
    Video.define_singleton_method(:fetch_title) { |_| nil }
    begin
      assert_no_difference "Video.count" do
        post videos_path, params: { youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
      end
      assert_redirected_to new_video_path
      assert_match(/Could not fetch/, flash[:alert])
    ensure
      Video.singleton_class.remove_method(:fetch_title)
    end
  end
end
