class Permission

  def initialize(user)
    @user = user
  end

  def create_pdf?
    @user.pro?
  end

end
