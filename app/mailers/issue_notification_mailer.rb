# encoding: UTF-8
class IssueNotificationMailer < Mailer
  include Rails.application.routes.url_helpers

  def send_notification(id)
    notification = Notification.find_by_id(id)
    return unless notification
    user, @issue = notification.user, notification.issue
    # TODO: user or issue deleted case
    @url = issue_url(@issue)
    mail(to: user.mail, subject: "Issue #{@issue.subject} requires your attention.")
  end
end
