class MusicBrainz
  require 'settings'
  require 'faraday'

  def self.fetch(search_string)
    conn = Faraday.new(:url => Settings.musicbrainz_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn.get search_string
  end
  def self.search_artists_by_name(name)
    MusicBrainz.fetch(''+ Settings.musicbrainz_artist_query_url + '"' + name +'"')
  end
  def get_all_release_groups(artist_id, type)
    #call fetch method
  end

  def get_release_group(group_id)
    #call fetch
  end

end