class UserNotificationsController < ApplicationController
  unloadable

  before_filter :find_currently_logged
  before_filter :find_and_authorize_notification, :only => :destroy

  def index
    @pending = @user.notifications.pending.order('notify_at ASC').
      includes(:issue).includes(:issue => :project)
    @paginate_pending, @pending = paginate @pending, :per_page => 15

    @sent = @user.notifications.sent.order('notify_at DESC').
      includes(:issue).includes(:issue => :project)
    @paginate_sent, @sent = paginate @sent, :per_page => 15
  end

  def destroy
    @notification.destroy
    flash[:notice] = l('notify.flash.deleted')
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
