class UserArtistsController < ApplicationController
  require 'json'
  respond_to :json

  def index
    data = params
    artist = UserArtist.new(data)
    #TODO need a check to see if its been added already
    #TODO need some error checking too
    artist.save
    data['genre_attribute'].each_with_index do |t,i|
      artist.genres.create(:tag => t)
    end
    render json:  'saved'
  end
end
