class PostmarkController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    email = Postmark::Mitt.new(request.body.read)
    Rails.logger.info email

    head :ok
  end

end
