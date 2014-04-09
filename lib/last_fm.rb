class LastFm
  require 'faraday'
  require 'open-uri'
  require 'track'

  #require statement for settings is in the config/environment.rb

  def self.encode_artist_name(artist_name)
    artist_name.gsub(/\s+/, '-')
  end
  def self.encode_release_name(release_name)
    release_name.gsub(/\s+/, '-')
  end
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

  def self.get_release(artist_name, release_name, mbid)

    response = LastFm.fetch(Settings.last_fm_release_info+ 'artist=' + artist_name + '&album=' + release_name + '&api_key=' + Settings.last_fm_api + '&format=json')
    json = ActiveSupport::JSON.decode(response.body)

    tracks = Array.new
    if json['album']['tracks']['track'].is_a? Array
      json['album']['tracks']['track'].each do |t|
        track = Track.new
        track.name = t['name']
        track.duration = t['duration']
        track.mbid = t['mbid']
        tracks.push(track)
      end
    else
      track = Track.new()
      track.name =  json['album']['tracks']['track']['name']
      track.duration = json['album']['tracks']['track']['duration']
      track.mbid = json['album']['tracks']['track']['mbid']
      tracks.push(track)
    end

    {
        :artist => artist_name,
        :artist_url_friendly => encode_artist_name(artist_name),
        :mbid => mbid,
        :release_name => json['album']['name'],
        :release_name_url_friendly => LastFm.encode_release_name(release_name),
        :release_date => Time.parse(json['album']['releasedate']),
        :release_mbid => json['album']['mbid'],
        :release_id => json['album']['id'],
        :release_image => json['album']['image'][2]['#text'],
        :tracks => tracks

    }
  end

  def self.get_similar_artists(mbid)
    response = LastFm.fetch(''+ Settings.get_string('last_fm_similar_artists') + '' + mbid + '&limit=20&api_key=' + Settings.last_fm_api + '&format=json')
    json = ActiveSupport::JSON.decode(response.body)

    all_artist = Array.new
    json['similarartists']['artist'].each do |artist|
      similar = {
          :name => artist['name'] ,
          :mbid => artist['mbid'],
          :url => artist['url'],
          :match => (artist['match'].to_i * 100)
      }
      all_artist.push(similar)
    end

    {
      :name => json['similarartists']['@attr']['artist'],
      :mbid => mbid,
      :similar_artists => all_artist
    }

  end

end