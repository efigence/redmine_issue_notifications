require 'redmine'
require_relative 'app/mailers/issue_notification_mailer'
Dir["./app/workers/*.rb"].each {|file| require file }

Redmine::Plugin.register :redmine_issue_notifications do
  name 'Redmine issue notifications plugin'
  author 'Jacek Grzybowski'
  description 'Plugin for sending issue notifications'
  version '0.0.1'

  requires_redmine :version_or_higher => '2.0.0'

  project_module :issue_tracking do
    permission :create_notifications,
      { :issues => [:create_notification] }, { :public => false, :require => :loggedin }
  end

  menu :top_menu,
      :user_notifications,
      { :controller => 'user_notifications', :action => 'index' },
      :caption => 'Issue Notifications',
      :if => Proc.new { User.current.logged? && User.current.notifications.any? }
end

ActionDispatch::Callbacks.to_prepare do
  User.send(:include, RedmineIssueNotifications::Patches::UserPatch)
  Issue.send(:include, RedmineIssueNotifications::Patches::IssuePatch)
  IssuesController.send(:include, RedmineIssueNotifications::Patches::IssuesControllerPatch)
end

require 'redmine_issue_notifications/hooks/show_issue_hook'
require 'redmine_issue_notifications'
