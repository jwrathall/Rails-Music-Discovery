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
    success = false
    message = ''
    error = ''

    if session[:user_id] != nil
      original_artist = UserArtist.get_by_mbid(params[:mbid])
      if !original_artist.nil?
        artist = original_artist.dup
        artist.user_id = session[:user_id]
        if artist.save
          original_artist.genres.each do |genre|
            artist.genres.create(:tag => genre.tag)
          end
          message = 'Saved artists'
          error = 'none'
          success = true
        else
          message = artist.errors
          error = 'not saved'
        end
      else
        artist = MusicBrainz.get_artist_by_mbid(params[:mbid])
        artist.user_id = session[:user_id]
        if artist.save
          message = 'Artist saved'
          error = 'none'
          success = true
        else
          message = artist.errors.message
          error = 'not saved'
          success = false
        end
      end
    else
      success = false
      message = 'User must be logged in to save artist'
      error = 'Used must login'
    end
    response = {:success => success,
                :message => message,
                :error => error
    }
    render json:  response
  end

  def destroy
    artist_id = params['_json']
    UserArtist.destroy(artist_id)
    render json:  artist_id
  end
end
