class UserController < ApplicationController
  def new

  end

  def create
    @user = User.new(params[:user])
    #check to see if one exists
    if User.exists(@user.username)
      flash[:notice] = 'user already exists'
      redirect_to(:action => 'create')
    else
      @user.save
      render('new')
    end
  end

  def sign_in
  end

  def forgot_password
  end

  def change_password
  end
end
