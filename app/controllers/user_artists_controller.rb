class UserArtistsController < ApplicationController
  respond_to :json

  def index
    @data = params['data']
  end
end
