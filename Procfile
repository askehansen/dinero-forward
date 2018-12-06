web: bundle exec puma -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq -q purchases -q mailers -c 10
release: bundle exec rake db:migrate
