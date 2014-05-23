class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :issue_id
      t.string :state, :nil => false, :default => "to_be_sent"
      t.datetime :notify_at
      t.string :sidekiq_task_id

      t.timestamps
    end
  end
end
