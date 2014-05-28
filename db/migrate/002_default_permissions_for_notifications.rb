class DefaultPermissionsForNotifications < ActiveRecord::Migration
  def up
    Role.all.select {|r| r.permissions.include?(:view_issues)}.each do |role|
      role.permissions << :create_notifications unless role.permissions.include?(:create_notifications)
      role.save!
    end
  end

  def down
    Role.all.each do |role|
      role.permissions.delete(:create_notifications)
      role.save!
    end
  end
end
