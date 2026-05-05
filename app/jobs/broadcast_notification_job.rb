class BroadcastNotificationJob < ApplicationJob
  queue_as :default

  def perform(video)
    ActionCable.server.broadcast("notifications", {
      title: video.title,
      shared_by: video.user.email_address
    })
  end
end
