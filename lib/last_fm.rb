class LastFm
  require 'faraday'
  require 'open-uri'
  #require statement for settings is in the config/environment.rb


  def self.fetch (search_string)
    conn = Faraday.new(:url => Settings.last_fm_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn.get search_string
  end
  def self.get_artist_detail_by_id(id)
    response = LastFm.fetch(''+ '?method=artist.getinfo&mbid=' + id + '&api_key=' + Settings.last_fm_api + '&format=json')
    lf_artist = ActiveSupport::JSON.decode(response.body)

    artist = {}
    artist['id'] = id
    artist['name'] = lf_artist['artist']['name']
    artist['tour'] = lf_artist['artist']['ontour']
    #condition ? if_true : if_false
    artist['placeformed'] = lf_artist['artist']['bio']['placeformed'] ? lf_artist['artist']['bio']['placeformed'] : ''
    if lf_artist['artist']['bio']['formationlist']
      if lf_artist['artist']['bio']['formationlist']['formation'].is_a? Array
        artist['date_formed'] =  lf_artist['artist']['bio']['formationlist']['formation']
      else
        artist['date_formed'] =  lf_artist['artist']['bio']['formationlist']
      end
    else
      artist['date_formed'] = ''
    end
    artist['tags'] = lf_artist['artist']['tags']['tag']
    artist['summary'] = lf_artist['artist']['bio']['summary'].html_safe
    artist['members'] = lf_artist['artist']['bandmembers'] ? lf_artist['artist']['bandmembers']['member'] : ''

    artist
  end
end