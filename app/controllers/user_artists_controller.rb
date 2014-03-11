class UserArtistsController < ApplicationController
  require 'json'
  respond_to :json

  def index
    #TODO check for user_id
    user_artists = UserArtist.all
    artists = {
        :count => user_artists.count,
        :user_artists => user_artists.as_json(:include => :genres)
    }
    render json: artists
  end
  def save
    message = ''
    status = 0
    data = params
    artist = UserArtist.new(data)
    artist.user_id = session[:user_id]
    #TODO need some error checking too
      if artist.save
        data['genre_attribute'].each do |t|
          artist.genres.create(:tag => t)
        end
        message = 'saved'
      else
        message = current_user
      end

    render json:  message
  end
  def destroy
    artist_id = params['_json']
    UserArtist.destroy(artist_id)
    render json:  artist_id
  end
end
