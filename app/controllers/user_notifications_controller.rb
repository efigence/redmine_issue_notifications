class UserNotificationsController < ApplicationController
  unloadable

  before_filter :find_currently_logged
  before_filter :find_and_authorize_notification, :only => :destroy

  def index
    @notifications = @user.notifications.pending.order('notify_at ASC').
      includes(:issue).includes(:issue => :project)
  end

  def destroy
    @notification.destroy
    flash[:notice] = "Notification deleted!"
    redirect_to user_notifications_path(@user)
  end

  private

  def find_and_authorize_notification
    @notification = Notification.find(params[:id])
    deny_access unless @notification.user == @user
  end

  def find_currently_logged
    if User.current.logged?
      @user = User.current
    else
      require_login
    end
  end
end
