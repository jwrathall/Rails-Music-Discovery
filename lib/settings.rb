class Settings
  attr_accessor :get_search_url

  def Settings.musicbrainz_url
    get_string_setting('musicbrainz_url')
  end

  def Settings.musicbrainz_artist_query_url
    get_string_setting('musicbrainz_artist_query')
  end

  def self.get_string_setting(value)
    APP_CONFIG[value].to_s
  end

end