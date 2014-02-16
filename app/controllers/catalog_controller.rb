class CatalogController < ApplicationController
  def new
  end

  def index
    #TODO check for user_id
    @artists = UserArtist.all()
  end

  def add
  end

  def delete
  end
end
