class UserNotificationsController < ApplicationController
  unloadable

  before_filter :find_currently_logged
  before_filter :find_and_authorize_notification, :only => :destroy

  def index
    @notifications = @user.issue_notifications.order("sent_at DESC, notify_at ASC").
      includes(:issue).includes(:issue => :project)

    if !params[:date_lookup].blank?
      date = params[:date_lookup].to_date
      @notifications = @notifications.where(notify_at: date..(date+1.day))
    end
    @notifications = @notifications.where(state: params[:state]) if !params[:state].blank?
    @paginate, @notifications = paginate @notifications, :per_page => 15
  end

  def destroy
    @notification.destroy
    flash[:notice] = l('notify.flash.deleted')
    redirect_to user_notifications_path(@user)
  end

  private

  def find_and_authorize_notification
    @notification = IssueNotification.find(params[:id])
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
