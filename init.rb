require 'redmine'
require_relative 'app/mailers/issue_notification_mailer'
Dir["./app/workers/*.rb"].each {|file| require file }

Redmine::Plugin.register :redmine_issue_notifications do
  name 'Redmine issue notifications plugin'
  author 'Jacek Grzybowski'
  description 'Plugin for sending issue notifications'
  version '0.0.1'

  menu :top_menu,
      :user_notifications,
      { :controller => 'user_notifications', :action => 'index' },
      :caption => 'Notifications',
      :if => Proc.new { User.current.logged? && User.current.notifications.any? }
end

ActionDispatch::Callbacks.to_prepare do
  User.send(:include, RedmineIssueNotifications::Patches::UserPatch)
  Issue.send(:include, RedmineIssueNotifications::Patches::IssuePatch)
  IssuesController.send(:include, RedmineIssueNotifications::Patches::IssuesControllerPatch)
end

require 'redmine_issue_notifications/hooks/show_issue_hook'
