class UserArtistsController < ApplicationController
  require 'json'
  require 'music_brainz'
  respond_to :json

  def index
    success = false
    artists = nil
    message = ''
    error = ''
    if session[:user_id] == nil
      message = 'You must login to view your artists'
      error = 'User not logged in'
    else

      user_artists = UserArtist.where('user_id = ?', session[:user_id]).to_a
      if user_artists
        artists = {
            :count => user_artists.count,
            :artists => user_artists.as_json(:include => :genres)
        }
        success = true
      else
        message = 'Could not loading artists'
        error = 'Error loading artists'
      end

    end
    response = {:success => success,
                :message => message,
                :error => error,
                :catalog => artists
              }
    render json: response
  end
  def save

    if session[:user_id] != nil
      #possibly save another query to musicbrainz
      original_artist = UserArtist.get_by_mbid(params)
      if original_artist
        clone_artist = original_artist.dup
        clone_artist.user_id = session[:user_id]
        original_artist.genres.each do |genre|
          clone_artist.genre_attribute << genre
        end
      else
        artist = MusicBrainz.get_artist_by_mbid(params)
        if artist.save
        else

        end
      end
    else
      message = 'You must login to save artists'
      error = 'User not logged in'
    end

  end
  def destroy
    artist_id = params['_json']
    UserArtist.destroy(artist_id)
    render json:  artist_id
  end
end


=begin
success = false
data = params
artist = UserArtist.new(data)
if session[:user_id] == nil

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
response = {:success => success,
            :message => message,
            :error => error
}
render json:  response.to_json
end=end
