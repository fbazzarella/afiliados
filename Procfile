web: bundle exec puma -e $RAILS_ENV -p 3000 -b unix:///tmp/$APP_NAME-$RAILS_ENV.sock --pidfile /tmp/$APP_NAME-$RAILS_ENV-web.pid
worker: bundle exec sidekiq -q default -q lists -q mailers --pidfile /tmp/$APP_NAME-$RAILS_ENV-worker.pid
