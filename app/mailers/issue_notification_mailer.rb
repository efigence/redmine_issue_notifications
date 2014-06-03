# encoding: UTF-8
class IssueNotificationMailer < Mailer

  def send_notification(id)
    notification = IssueNotification.find_by_id(id)
    return unless notification
    @user, @issue = notification.user, notification.issue
    return unless @user && @user.active?
    @url = issue_url(@issue)
    I18n.with_locale(locale_for_user) do
      mail :to => @user.mail,
           :subject => t('notify.email.basic_subject', :issue => @issue.subject)
    end
  end

  def issue_deleted(id)
    notification = IssueNotification.find_by_id(id)
    return unless notification
    @user = notification.user
    @url = user_notifications_url
    I18n.with_locale(locale_for_user) do
      mail :to => @user.mail,
           :subject => t('notify.email.deleted_subject')
    end
  end

  private

  def locale_for_user
    lang = @user.language || 'en'
    RedmineIssueNotifications::SUPPORTED_LOCALES.include?(lang) ? lang : "en"
  end
end
