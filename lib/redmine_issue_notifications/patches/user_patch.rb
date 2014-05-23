require_dependency 'user'

module RedmineIssueNotifications
  module Patches
    module UserPatch
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
