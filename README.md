# Redmine Issue Notifications plugin

Plugin which enables users to set email notifications for issues, sent at user-defined time.

# Requirements

Developed and tested on Redmine 2.5.1.
Redmine > 2.0 is required.

# Installation

To use this plugin you must install and configure `sidekiq` first, which is used to schedule and send email notifications. To use `sidekiq` with redmine you should use `redmine_sidekiq` plugin. You can add it to redmine by following the instructions provided on its github page: https://github.com/ogom/redmine_sidekiq

After you successfully install `redmine_sidekiq`:

1. Go to your Redmine installation's plugins/ directory.
2. Clone this repo: `$ git clone https://github.com/efigence/redmine_issue_notifications`
3. Go back to root directory.
4. Install dependencies (`clockwork` & `daemons` gems): `$ bundle install`
4. Migrate the database: `$ rake redmine:plugins:migrate RAILS_ENV=production`
5. Move `clockwork.rb` file to redmine root directory: `$ mv plugins/redmine_issue_notifications/clockwork.rb ./clockwork.rb`
6. Restart Redmine.
7. Move `sidekiq.yml` file to redmine config directory: `$ mv plugins/redmine_issue_notifications/sidekiq.yml ./config/sidekiq.yml`
8. Start sidekiq: `$ bundle exec sidekiq -C config/sidekiq.yml -e production`
9. Start clockwork: `$ RAILS_ENV=production bundle exec clockworkd -c clockwork.rb -l --log-dir=log --pid-dir=tmp/pids -i redmine start`

You can find more information about clockwork [here](https://github.com/tomykaira/clockwork) and about sidekiq [here](https://github.com/mperham/sidekiq)

# Configuration

In `clockwork.rb` you can define how often should `sidekiq` be called to schedule pending emails sending process. Default interval is set to 5 minutes. You can read more about `clockwork` and its configuration here: https://github.com/tomykaira/clockwork

Plugin also creates a new permission called `Create notifications`. By default members of all roles with `view_issue` privileges are allowed to create notifications. You can change this behaviour by visiting `Administration -> Roles and permissions` page.

# Usage

Visit issue page. Menu containing buttons `Edit`, `Log time`, `Watch`, etc should now be extended by `Notification` button. Simply click on the link and select when you would like to be reminded about the issue. On the chosen time you will receive email notification with the issue link.

After creating a notification a top menu link `Notifications` will show up. Visit this page to see a list of all your scheduled and pending notifications.

# License

    Redmine Issue Notifications plugin
    Copyright (C) 2014  efigence S.A.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
