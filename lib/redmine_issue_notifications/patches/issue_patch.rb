require_dependency 'issue'

module RedmineIssueNotifications
  module Patches
    module IssuePatch
      def self.included(base)
        base.class_eval do
          unloadable
          base.send(:include, InstanceMethods)
          has_many :notifications
        end
      end
      module InstanceMethods
      end
    end
  end
end
