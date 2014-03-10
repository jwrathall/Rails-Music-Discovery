class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.get_by_username(params[:email])
    @user.password = params[:password]

    if @user.authenticate
      session[:user_id] = @user.id
      redirect_to(:controller => 'catalog')
     else
       redirect_to(:action => 'new')
     end
  end

  def destroy
  end
end
