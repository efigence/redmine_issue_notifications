class IssueNotificationScheduleWorker
  include Sidekiq::Worker

  sidekiq_options queue: :issue_notifications_schedule,
    backtrace: true

  def perform
    return unless IssueNotification.to_send.any?
    to_send_ids = IssueNotification.to_send.pluck(:id)
    to_send_ids.each do |id|
      @task_id = IssueNotificationSendWorker.perform_async(id)
      @notification = IssueNotification.find(id)
      update_notification_attrs
    end
  end

  private

  def update_notification_attrs
    @notification.state = 'sending'
    @notification.sidekiq_task_id = @task_id
    @notification.save
  end
end
