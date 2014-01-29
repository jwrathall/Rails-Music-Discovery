class SimilarController < ApplicationController
  require 'similar_artist'
  require 'artist'
  def index

    @mbid = params['id']
    @test = Settings.get_string('last_fm_similar_artists')
    conn_lf = Faraday.new(:url => Settings.last_fm_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end


    response = conn_lf.get ''+ ''+ Settings.get_string('last_fm_similar_artists') + '' + @mbid + '&limit=20&api_key=' + Settings.last_fm_api + '&format=json'

    json = ActiveSupport::JSON.decode(response.body)


    artists = json['similarartists']['artist']
    @band_name = json['similarartists']['@attr']['artist']
        all_artist = Array.new
    artists.each do |artist|

      art = SimilarArtist.new(
                      name = artist['name'],
                      mbid = artist['mbid'],
                      url = artist['url'],
                      match = artist['match']
                    )

      all_artist.push(art)
     end
    @artists = all_artist
  end
end
