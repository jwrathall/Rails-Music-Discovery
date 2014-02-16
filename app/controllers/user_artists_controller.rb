class UserArtistsController < ApplicationController
  require 'json'
  respond_to :json

  def index
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
end
