#### PLACE IT IN REDMINE ROOT DIRECTORY ####

unless %w(development production test).include? ENV["RAILS_ENV"]
  # Sets RAILS_ENV to production if no env. var was set
  ENV['RAILS_ENV'] = 'production'
end

require_relative "./config/environment"
require "clockwork"

module Clockwork
  every(2.minutes, 'scheduling.job') do
    NotificationScheduleWorker.perform_async
  end

  every(1.day, 'morning-cleanup.job', :at => '05:00') do
    NotificationCleanupWorker.perform_async
  end
end
