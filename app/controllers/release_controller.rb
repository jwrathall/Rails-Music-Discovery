class ReleaseController < ApplicationController
  require 'release'
  require 'track'
  def index
    @release_name = params['release']
    @artist_name = params['artist']
    @release_name_dash = @release_name.gsub(/\s+/, '-')
    @artist_name_dash = @artist_name.gsub(/\s+/, '-')


    conn_lf = Faraday.new(:url => Settings.last_fm_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end


    response = conn_lf.get ''+ Settings.get_string('last_fm_release_info') + 'artist=' + @artist_name + '&album=' + @release_name + '&api_key=' + Settings.last_fm_api + '&format=json'

    json = ActiveSupport::JSON.decode(response.body)


      release = Release.new()
      release.release_name = json['album']['name']
      release.release_date = json['album']['releasedate']
      release.mbid = json['album']['mbid']
      release.id = json['album']['id']
      release.release_image = json['album']['image'][2]['#text']
      tracks = Array.new
      json['album']['tracks']['track'].each do |t|
        track = Track.new
        track.name = t['name']
        track.duration = t['duration']
        track.mbid = t['mbid']
        tracks.push(track)
      end
      release.tracks = tracks
      @sec =   324%60
      @tracks = json['album']['tracks']['track']
      @release = release

     @json = json

  end
end
