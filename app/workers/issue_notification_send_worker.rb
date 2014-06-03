class IssueNotificationSendWorker
  include Sidekiq::Worker

  sidekiq_options queue: :issue_notifications,
    backtrace: true


  def perform(id)
    notification = IssueNotification.find(id)
    if notification.issue
      IssueNotificationMailer.sidekiq_delay.send_notification(id)
    else
      IssueNotificationMailer.sidekiq_delay.issue_deleted(id)
    end
    notification.state = "sent"
    notification.sent_at = Time.now.to_datetime
    notification.save!
  end
end
