class UserArtistsController < ApplicationController
  require 'json'
  respond_to :json

  def index
    #TODO check for user_id
    artists = UserArtist.all
    render json: artists.to_json(:include => :genres)
  end
  def save
    message = ''
    status = 0
    data = params
    artist = UserArtist.new(data)
    #TODO need some error checking too
      if artist.save
        data['genre_attribute'].each_with_index do |t,i|
          artist.genres.create(:tag => t)
        end
        message = 'saved'
        status = 200
      else
        message = 'exists'
        status = 409
      end

    render json:  message, :status => status
  end
  def destroy
    artist_id = params['_json']
    UserArtist.destroy(artist_id)
    render json:  artist_id
  end
end
