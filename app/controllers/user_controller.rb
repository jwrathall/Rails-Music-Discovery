class UserController < ApplicationController
  def new
  end

  def create
    @user = User.new(params[:user])
    #check to see if one exists
    @user.save
  end

  def sign_in
  end

  def forgot_password
  end

  def change_password
  end
end
