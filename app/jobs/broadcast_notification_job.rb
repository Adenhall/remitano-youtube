class BroadcastNotificationJob < ApplicationJob
  queue_as :default

  def perform(video)
    payload = { title: video.title, shared_by: video.user.email_address }
    User.where.not(id: video.user_id).find_each do |user|
      NotificationsChannel.broadcast_to(user, payload)
    end
  end
end
