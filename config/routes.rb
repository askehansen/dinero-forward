require 'sidekiq/web'

Rails.application.routes.draw do

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end if Rails.env.production?

  mount Sidekiq::Web => '/sidekiq'

  root to: 'users#new'

  resources :users

  resources :emails, only: :create
end
