class VideosController < ApplicationController
  def new
    render inertia: "Videos/New"
  end

  def create
    url = params[:youtube_url].to_s.strip
    youtube_id = Video.extract_id_from(url)

    unless youtube_id
      return redirect_to new_video_path, alert: "Please enter a valid YouTube URL."
    end

    title = Video.fetch_title(url)
    unless title
      return redirect_to new_video_path, alert: "Could not fetch video title. Please check the URL and try again."
    end

    video = Current.user.videos.build(youtube_url: url, youtube_id: youtube_id, title: title)
    if video.save
      redirect_to root_path, notice: "#{title} shared successfully!"
    else
      redirect_to new_video_path, alert: video.errors.full_messages.first
    end
  end
end
