class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.where(
              'username =?', params[:email]
              )
              .first()
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to(:controller => 'catalog')
    else
      flash[:notice] = 'credentials not valid'
      render('new')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to(root_path)
  end
end
