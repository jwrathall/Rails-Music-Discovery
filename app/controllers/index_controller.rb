class IndexController < ApplicationController
  require 'faraday'
  require 'nokogiri'
  require 'open-uri'
  require 'artist'
  require 'music_brainz'

  #require statement for settings is in the config/environment.rb

  def index
       @doc = ''
    #might need something like this
    #http://www.musicbrainz.org/ws/2/release/?query=date:2014-03-04+TO+2014-03-11%20and%20country:US%20and%20type:album|ep|
    #http://www.musicbrainz.org/ws/2/release-group/?query=date:2014-03-11+TO+2014-03-04%20and%20country:xw%20and%20type:album
    #help with searching: http://forums.musicbrainz.org/viewtopic.php?pid=22929#p22929
  end

  def get
    band_name = params['band']

    response = MusicBrainz.search_artists_by_name(band_name)

    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!
    #xml.xpath('//metadata:artist-list', 'metadata' => 'http://musicbrainz.org/ns/mmd-2.0#').each do |artistlist|
    #   @doc =  artistlist.xpath('ext:score', 'ext' => 'http://musicbrainz.org/ns/ext#-2.0' ).text
      #@doc =  artistlist.xpath('metadata:artist', 'metadata' => 'http://musicbrainz.org/ns/mmd-2.0#' ).attribute('ext:score')
    #end
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

    @output = artists

  render :search_results


  end
end
