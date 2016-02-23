web: bundle exec puma -e $RAILS_ENV -b unix:///tmp/$APP_NAME-$RAILS_ENV.sock --pidfile /tmp/$APP_NAME-$RAILS_ENV-web.pid
worker: bundle exec sidekiq -c 2 -q default -q lists -q mailers --pidfile /tmp/$APP_NAME-$RAILS_ENV-worker.pid
