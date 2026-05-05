require "test_helper"

class VideoTest < ActiveSupport::TestCase
  def valid_video(overrides = {})
    Video.new({
      user: users(:one),
      youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      title: "Rick Astley - Never Gonna Give You Up"
    }.merge(overrides))
  end

  test "is valid with a watch URL and title" do
    assert valid_video.valid?
  end

  test "extracts youtube_id from watch URL" do
    v = valid_video(youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
    v.valid?
    assert_equal "dQw4w9WgXcQ", v.youtube_id
  end

  test "extracts youtube_id from short youtu.be URL" do
    v = valid_video(youtube_url: "https://youtu.be/dQw4w9WgXcQ")
    v.valid?
    assert_equal "dQw4w9WgXcQ", v.youtube_id
  end

  test "extracts youtube_id when URL has extra query params" do
    v = valid_video(youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=42")
    v.valid?
    assert_equal "dQw4w9WgXcQ", v.youtube_id
  end

  test "rejects non-YouTube URLs" do
    v = valid_video(youtube_url: "https://vimeo.com/123456")
    assert_not v.valid?
    assert_includes v.errors[:youtube_url], "must be a valid YouTube URL"
  end

  test "rejects blank URL" do
    v = valid_video(youtube_url: "")
    assert_not v.valid?
  end

  test "requires title" do
    v = valid_video(title: nil)
    assert_not v.valid?
    assert_includes v.errors[:title], "can't be blank"
  end

  test "requires user" do
    v = valid_video(user: nil)
    assert_not v.valid?
    assert_includes v.errors[:user], "must exist"
  end

  test "extract_id_from returns video ID from watch URL" do
    assert_equal "dQw4w9WgXcQ", Video.extract_id_from("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
  end

  test "extract_id_from returns video ID from short URL" do
    assert_equal "dQw4w9WgXcQ", Video.extract_id_from("https://youtu.be/dQw4w9WgXcQ")
  end

  test "extract_id_from returns nil for non-YouTube URL" do
    assert_nil Video.extract_id_from("https://vimeo.com/123456")
  end
end
