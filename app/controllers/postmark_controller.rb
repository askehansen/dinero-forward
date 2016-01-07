class PostmarkController < ApplicationController

  def create
    email = Postmark::Mitt.new(request.body.read)
    Rails.logger.info email

    head :ok
  end

end
