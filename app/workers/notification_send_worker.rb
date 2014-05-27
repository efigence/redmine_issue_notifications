class NotificationSendWorker
  include Sidekiq::Worker

  def perform(id)
    notification = Notification.find(id)
    if notification.issue
      IssueNotificationMailer.sidekiq_delay.send_notification(id)
    else
      IssueNotificationMailer.sidekiq_delay.issue_deleted(id)
    end
    notification.update_attribute(:state, "sent")
  end
end
