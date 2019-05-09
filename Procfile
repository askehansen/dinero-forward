web: bundle exec puma -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq -q action_mailbox_routing -q purchases -q mailers -q active_storage_analysis -q default -c 10
release: bundle exec rake db:migrate
