module RedmineIssueNotifications
  module Hooks
    class ShowIssueHook < Redmine::Hook::ViewListener
      render_on(:view_issues_show_details_bottom, :partial => 'issue/add_notifications', :layout => false)
    end
  end
end
