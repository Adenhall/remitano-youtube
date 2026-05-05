require "net/http"
require "json"
require "cgi"

class Video < ApplicationRecord
  belongs_to :user

  # Anchored — used by format: validation (Brakeman requires \A and \z)
  YOUTUBE_URL_FORMAT = /\A(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/watch\?.*?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})[^\s]*\z/
  # Unanchored — used to extract the 11-char ID from any URL string
  YOUTUBE_ID_REGEX   = /(?:youtube\.com\/watch\?.*?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})/

  validates :youtube_url, presence: true, format: {
    with: YOUTUBE_URL_FORMAT,
    message: "must be a valid YouTube URL"
  }
  validates :youtube_id, presence: true
  validates :title, presence: true

  before_validation :extract_youtube_id

  def self.extract_id_from(url)
    url.to_s.match(YOUTUBE_ID_REGEX)&.captures&.first
  end

  def self.fetch_title(url)
    oembed = URI("https://www.youtube.com/oembed?url=#{CGI.escape(url)}&format=json")
    JSON.parse(Net::HTTP.get(oembed))["title"]
  rescue
    nil
  end

  private

  def extract_youtube_id
    self.youtube_id = self.class.extract_id_from(youtube_url)
  end
end
