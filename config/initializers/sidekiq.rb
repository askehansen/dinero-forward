require 'sidekiq/web'

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end
else
  require 'sidekiq/testing/inline'
end

Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
Sidekiq::Web.set :sessions, Rails.application.config.session_options
