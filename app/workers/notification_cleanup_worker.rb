class NotificationCleanupWorker
  include Sidekiq::Worker

  def perform
    Notification.cleanupable.destroy_all
  end
end
