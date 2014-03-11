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
    success = false
    data = params
    artist = UserArtist.new(data)
    if session[:user_id] == nil
      message = 'You must login to save artists'
      error = 'User not logged in'
    else
      artist.user_id = session[:user_id]
      if artist.save
        data['genre_attribute'].each do |t|
          artist.genres.create(:tag => t)
        end
        message = 'Successfully saved to your catalog'
        success = true
        error= 'none'
      else
        message = 'Artists already exists in your catalog'
        error = 'Artist already exists'

      end
    end
    response = {:success => success, :message => message, :error => error}
    render json:  response.to_json
  end
  def destroy
    artist_id = params['_json']
    UserArtist.destroy(artist_id)
    render json:  artist_id
  end
end
