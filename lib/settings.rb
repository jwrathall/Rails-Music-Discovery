class Settings
  attr_accessor :get_search_url

  def Settings.musicbrainz_url
    get_string_setting('musicbrainz_url')
  end

  def Settings.musicbrainz_artist_query_url
    get_string_setting('musicbrainz_artist_query')
  end

  def Settings.musicbrainz_artist_by_mbid
    get_string_setting('musicbrainz_artist_by_mbid')
  end

  def Settings.musicbrainz_release_query
    get_string_setting('musicbrainz_release_query')
  end

  def Settings.last_fm_api
    get_string_setting('last_fm_api_key')
  end

  def Settings.last_fm_url
    get_string_setting('last_fm_url')
  end

  def Settings.get_string(value)
    get_string_setting(value.to_s)
  end

  def self.get_string_setting(value)
    APP_CONFIG[value].to_s
  end

end