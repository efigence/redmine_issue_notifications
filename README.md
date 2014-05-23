# work in progress

# to start (temp):

- clone to plugins/ 
- install redmine_sidekiq plugin
- bundle install
- migrate plugin
- move clockwork.rb to redmine root directory
- `bundle exec sidekiq`
- `RAILS_ENV=development bundle exec clockworkd -c clockwork.rb -l --log-dir=log --pid-dir=tmp/pids -i redmine start`
