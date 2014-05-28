module RedmineIssueNotifications
  SUPPORTED_LOCALES = Dir["#{Rails.root}/plugins/redmine_issue_notifications/app/views/issue_notification_mailer/*.erb"].
                        map{ |p| p.split('/').last.split('.')[1] }.uniq
end
