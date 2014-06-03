class IssueNotificationCleanupWorker
  include Sidekiq::Worker

  sidekiq_options queue: :issue_notifications_cleanup,
    backtrace: true

  def perform
    IssueNotification.cleanupable.destroy_all
  end
end
