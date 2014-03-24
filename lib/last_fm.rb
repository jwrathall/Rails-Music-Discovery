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
    ActiveSupport::JSON.decode(response.body)
  end
end