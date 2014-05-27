class NotificationScheduleWorker
  include Sidekiq::Worker

  def perform
    return unless Notification.to_send.any?
    to_send_ids = Notification.to_send.pluck(:id)
    to_send_ids.each do |id|
      @task_id = NotificationSendWorker.perform_async(id)
      @notification = Notification.find(id)
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
