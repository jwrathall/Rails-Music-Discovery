class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    #authentication stuff here
    #put stuff into the session here too
  end

  def destroy
  end
end
