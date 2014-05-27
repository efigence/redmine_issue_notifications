# encoding: UTF-8
class IssueNotificationMailer < Mailer
  include Rails.application.routes.url_helpers

  def send_notification(id)
    notification = Notification.find_by_id(id)
    return unless notification
    user, @issue = notification.user, notification.issue
    return unless user && user.active?
    @url = issue_url(@issue)
    lang = user.language || 'en'
    path = "#{Rails.root}/plugins/redmine_issue_notifications/app/views/issue_notification_mailer/send_notification.#{lang}.html.erb"
    locale = File.exists?(path) ? lang : "en"

    mail :to => user.mail,
         :subject => l('notify.email.basic_subject', :issue => @issue.subject),
         :locale => locale do |format|
      format.html { render ("send_notification." + locale) }
      format.text { render ("send_notification." + locale) }
    end
  end

  def issue_deleted(id)
    notification = Notification.find_by_id(id)
    return unless notification
    user = notification.user
    @url = user_notifications_url

    ### TODO: locales
    mail(to: user.mail, subject: "Issue which required your attention was deleted.")
  end
end
