class NotificationScheduleWorker
  include Sidekiq::Worker

  def perform
    return unless Notification.to_send.any?
    to_send_ids = Notification.to_send.pluck(:id)
    to_send_ids.each do |id|
      task_id = NotificationSendWorker.perform_async(id)
      notification = Notification.find(id)
      notification.update_attributes(:state => 'sending', :sidekiq_task_id => task_id)
    end
  end
end
