class UsersController < ApplicationController
  before_action :set_stats
  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user].permit!

    unless @user.valid?
      flash[:error] = 'Du skal angive både firma ID og API nøgle'
      return render :new
    end

    begin
      client = Dinero.new(organization_id: @user.organization_id, api_key: @user.api_key)
      client.authorize!
      client.contacts
    rescue Exception => e
      flash[:error] = 'Kunne ikke godkendes. Har du angivet dit firma ID rigtigt?'
      return render :new
    end

    flash[:error] = nil

    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find params[:id]
  end

  private

  def set_stats
    @processed = Purchase.processed_count
    @users = User.count
  end
end
