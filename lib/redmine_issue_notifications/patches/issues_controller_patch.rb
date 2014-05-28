require_dependency 'issues_controller'

module RedmineIssueNotifications
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable
          base.send(:include, InstanceMethods)
          prepend_before_filter :find_issue_and_project, :only => [:create_notification]
          append_before_filter :set_notification, :only => [:show, :create_notification],
           :if => proc { User.current.logged? }
        end
      end
      module InstanceMethods
        def find_issue_and_project
          @issue = Issue.find(params[:id])
          @project = @issue.project
        end
        def create_notification
          datetime_string = params[:notification][:notify_at]
          @notification.notify_at =
            if (time_zone = User.current.time_zone)
              time_zone.parse(datetime_string)
            else
              datetime_string.to_time(:local).to_datetime
            end
          if @notification.save
            flash[:notice] = l('notify.flash.notice')
          else
            flash[:error] = l('notify.flash.error')
          end
          redirect_to issue_path(@issue)
        end
        def set_notification
          @notification = @issue.notifications.build(user: User.current)
        end
        private :set_notification
      end
    end
  end
end
