class EmailsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    puts params
    events = JSON.parse params[:mandrill_events]
    events.each do |event|
      if event['event'] == 'inbound'
        ProcessEmail.call msg: event['msg']
      end
    end

    head :ok
  end

end
