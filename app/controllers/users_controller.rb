class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user].permit!

    begin
      client = Dinero.new(organization_id: @user.organization_id, api_key: @user.api_key)
      client.authorize!
      client.contacts
    rescue Exception => e
      flash[:error] = 'Kunne ikke godkendes. Har du angivet dit organizations nr. rigtigt?'
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
end
