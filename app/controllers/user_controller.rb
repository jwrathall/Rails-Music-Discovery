class UserController < ApplicationController
  def new
    flash[:notice]=''
    @user = User.new()
  end

  def create
    @user = User.new(params[:user])
    if @user.valid?
      begin
        @user.save!
      rescue ActiveRecord::RecordNotUnique
        @user.errors.add(:username, 'has already used')
      else
        flash[:notice] = 'User saved.'
      end
    end
      render('new')
  end

  def sign_in
  end

  def forgot_password
  end

  def change_password
  end
end
