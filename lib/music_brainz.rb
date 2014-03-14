class MusicBrainz
  require 'faraday'
  require 'artist'
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
  def get_artist_by_mbid(id)
    response =  MusicBrainz.fetch(''+ Settings.musicbrainz_artist_by_mbid + '"' + id +'"&fmt=json')
    json = ActiveSupport::JSON.decode(response.body)
    artist = Artist.new(
                        :mbid => json['id'],
                        :name => json['name'],
                        :artist_type => json['type'],
                        :country_name => json['area'].nil? ? '' : json['area']['name'],
                        :country_id => json['area'].nil? ? nil : json['area']['id'],
                        :area_name => json['begin-area'].nil? ? '' : json['begin-area']['name'],
                        :area_id => json['begin-area'].nil? ? '' : json['begin-area']['id']
                        )
    unless json['tags'].nil?
      tags_list = json['tags'].to_a
      tags_list.each do |tag|
        artist.genre_attribute = tag['name']
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
end
