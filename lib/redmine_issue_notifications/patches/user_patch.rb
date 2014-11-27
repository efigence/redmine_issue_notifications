require_dependency 'user'

module RedmineIssueNotifications
  module Patches
    module UserPatch
      def self.included(base)
        base.class_eval do
          unloadable
          base.send(:include, InstanceMethods)
          has_many :issue_notifications
          before_destroy :delete_issue_notifications
          after_save :delete_issue_notifications, :if => Proc.new { self.status == User::STATUS_LOCKED }
        end
      end
      module InstanceMethods
        def delete_issue_notifications
          IssueNotification.destroy_all(:user_id => self.id)
        end
      end
    end
  end
end
