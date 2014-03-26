class MusicBrainz
  require 'faraday'
  require 'nokogiri'
  require 'open-uri'
  #require statement for settings is in the config/environment.rb

  def self.fetch(search_string)
    conn = Faraday.new(:url => Settings.musicbrainz_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn.get search_string
  end
  def self.search_artists_by_name(name)
   response =  MusicBrainz.fetch(''+ Settings.musicbrainz_artist_query_url + '"' + name +'"&fmt=json')
   ActiveSupport::JSON.decode(response.body)
=begin
    #TODO rewrite this using JSON
    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!
    artists = Array.new
    xml.xpath('//metadata//artist-list//artist').each do |artist|
      myartist = Artist.new()
      myartist.relevance = artist.attribute('score').to_s
      myartist.artist_type = artist.attribute('type').to_s
      myartist.name = artist.child().text()
      myartist.mbid = artist.attribute('id').to_s

      myartist.country_id = artist.xpath('area/@id').to_s
      if artist.xpath('area/name') != ''
        myartist.country_name = artist.xpath('area/name').text()
      else
        myartist.country_name = ''
      end
      myartist.area_id = artist.xpath('begin-area/@id').to_s
      myartist.area_name =artist.xpath('begin-area/name').text()

      if artist.xpath('tag-list/tag').nil?
        myartist.genre_attribute  =''
      else
        tags = Array.new
        artist.xpath('tag-list/tag').each do |tag|
          tags.push(tag.xpath('name').text())
        end
        myartist.genre_attribute = tags
      end



      myartist.description = artist.xpath('disambiguation').text()
      artists.push(myartist)
    end
    artists
=end
  end
  def self.get_artist_by_mbid(id)
    response =  MusicBrainz.fetch(''+ Settings.musicbrainz_artist_by_mbid + '"' + id +'"&fmt=json')
    json = ActiveSupport::JSON.decode(response.body)
    json_artist = json['artist'][0]
    artist = UserArtist.new(
                        :mbid => json_artist['id'],
                        :name => json_artist['name'],
                        :artist_type => json_artist['type'],
                        :country_name => json_artist['area'].nil? ? '' : json_artist['area']['name'],
                        :country_id => json_artist['area'].nil? ? nil : json_artist['area']['id'],
                        :area_name => json_artist['begin-area'].nil? ? '' : json_artist['begin-area']['name'],
                        :area_id => json_artist['begin-area'].nil? ? '' : json_artist['begin-area']['id']
                        )

    if json_artist['tags'].nil?
      artist.genres_attributes = ''
    else
      json_artist['tags'].each do |t|
        artist.genres.build(:tag => t['name'])
      end
    end
    artist
  end
  def get_all_release_groups(artist_id, type)
    #call fetch method
  end

  def get_release_group(group_id)
    #call fetch
  end

  def self.get_new_releases (date)
    #initially used json but musicbrainz changed it and it broke everything, back to xml
    #response = MusicBrainz.fetch(''+ Settings.musicbrainz_releases_by_date + '"' + date +'"&fmt=json')
    response = MusicBrainz.fetch(''+ Settings.musicbrainz_releases_by_date + date)
    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!
    releases = Array.new
    xml.xpath('//metadata//release-list//release').each do |release|
      r = {
            :id => release.attribute('id').text,
            :title => release.xpath('title').text,
            :type => release.xpath('release-group/primary-type').text,
            :artist_id => release.xpath('artist-credit/name-credit/artist').attribute('id').text,
            :artist_name => release.xpath('artist-credit/name-credit/artist/name').text,
            :label => release.xpath('label-info-list/label-info/name').text
          }
      releases.push(r)
    end
    releases
  end
end
