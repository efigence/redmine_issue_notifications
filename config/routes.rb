match 'issues/:id/notifications', :to => 'issues#create_notification', :via => :post, :as => 'issue_notification'
get 'user_notifications', :to => 'user_notifications#index', :as => 'user_notifications'
post 'user_notifications', :to => 'user_notifications#destroy', :as => 'destroy_notification'
