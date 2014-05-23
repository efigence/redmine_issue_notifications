class NotificationSendWorker
  include Sidekiq::Worker

  def perform(id)
    IssueNotificationMailer.sidekiq_delay.send_notification(id)
    Notification.find(id).update_attribute(:state, "sent")
  end
end
