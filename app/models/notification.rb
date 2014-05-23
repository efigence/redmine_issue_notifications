class Notification < ActiveRecord::Base
  unloadable

  STATE_OPTS = %w(to_be_sent sending sent failed)

  belongs_to :user
  belongs_to :issue

  attr_accessible :notify_at, :user, :state, :sidekiq_task_id

  validates_presence_of :user_id, :issue_id, :notify_at, :state

  validates_inclusion_of :state, :in => STATE_OPTS

  validate :proper_date_chosen

  scope :pending, -> { where('notify_at > ?', Time.now.to_datetime) }

  scope :to_send, -> { where(state: 'to_be_sent').where('notify_at <= ?', Time.now.to_datetime) }

  private

  def proper_date_chosen
    if notify_at < Time.now.to_datetime
      errors.add(:notify_at, "cant be lower than time now")
    end
  end
end