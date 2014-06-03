#### PLACE IT IN REDMINE ROOT DIRECTORY ####

unless %w(development production test).include? ENV["RAILS_ENV"]
  # Sets RAILS_ENV to production if no env. var was set
  ENV['RAILS_ENV'] = 'production'
end

require_relative "./config/environment"
require "clockwork"

module Clockwork
  @@stats = Sidekiq::Stats.new

  every(5.minutes, 'issue_notifications.scheduling.job') do
    # change queue name if you don't use default sidekiq.yml config file
    if @@stats.queues["issue_notifications_schedule"].to_i < 5
      IssueNotificationScheduleWorker.perform_async
    end
  end


  every(1.day, 'morning-cleanup.job', :at => '05:00') do
    IssueNotificationCleanupWorker.perform_async
  end
end
