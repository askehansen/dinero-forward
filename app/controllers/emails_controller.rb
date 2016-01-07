class EmailsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    events = JSON.parse params[:mandrill_events]
    events.each do |event|
      if event['event'] == 'inbound'
        ProcessEmail.call message: event['msg']
      end
    end

    head :ok
  end

end
