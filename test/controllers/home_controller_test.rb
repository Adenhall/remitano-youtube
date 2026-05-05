require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "home passes videos to Inertia props newest first" do
    get root_path
    videos = inertia.props[:videos]
    assert_not_nil videos
    assert_equal 2, videos.length
    assert_equal videos(:one).id, videos[0][:id]
    assert_equal videos(:two).id, videos[1][:id]
  end

  test "home video props include required fields" do
    get root_path
    video = inertia.props[:videos].first
    assert_equal videos(:one).youtube_id, video[:youtube_id]
    assert_equal videos(:one).title, video[:title]
    assert_equal users(:one).email_address, video[:shared_by]
    assert video[:shared_at]
  end

  test "home passes empty videos array when none exist" do
    Video.delete_all
    get root_path
    assert_equal [], inertia.props[:videos]
  end
end
