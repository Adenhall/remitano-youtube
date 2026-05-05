class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    videos = Video.includes(:user).order(created_at: :desc).map do |v|
      { id: v.id, youtube_id: v.youtube_id, title: v.title,
        shared_by: v.user.email_address, shared_at: v.created_at }
    end
    render inertia: "Home", props: { videos: }
  end
end
