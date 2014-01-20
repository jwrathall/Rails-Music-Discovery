class IndexController < ApplicationController
  require 'faraday'
  require 'nokogiri'
  require 'open-uri'
  require 'artist'
  #require statement for settings is in the config/environment.rb

  def index
       @doc = ''
  end

  def get
    band_name = params['band']

    conn = Faraday.new(:url => Settings.musicbrainz_url) do |faraday|
       faraday.request  :url_encoded             # form-encode POST params
       faraday.response :logger                  # log requests to STDOUT
       faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
     end

    response = conn.get ''+ Settings.musicbrainz_artist_query_url + '"' + band_name +'"'

    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!
    #xml.xpath('//metadata:artist-list', 'metadata' => 'http://musicbrainz.org/ns/mmd-2.0#').each do |artistlist|
    #   @doc =  artistlist.xpath('ext:score', 'ext' => 'http://musicbrainz.org/ns/ext#-2.0' ).text
      #@doc =  artistlist.xpath('metadata:artist', 'metadata' => 'http://musicbrainz.org/ns/mmd-2.0#' ).attribute('ext:score')
    #end
    artists = Array.new
    xml.xpath('//metadata//artist-list//artist').each do |artist|
      myartist = Artist.new()
      myartist.relevance = artist.attribute('score')
      myartist.type = artist.attribute('type')
      myartist.name = artist.child().text()
      myartist.id = artist.attribute('id')

      myartist.country_id = artist.xpath('area/@id')
      if artist.xpath('area/name') != ''
        myartist.country_name = artist.xpath('area/name').text()
      else
        myartist.country_name = ''
      end
      myartist.area_id = artist.xpath('begin-area/@id')
      myartist.area_name =artist.xpath('begin-area/name').text()

      if artist.xpath('tag-list/tag').nil?
        myartist.genre  =''
      else
        tags = Array.new
        artist.xpath('tag-list/tag').each do |tag|
         tags.push(tag.xpath('name').text())
        end
        myartist.genre = tags
      end



      myartist.description = artist.xpath('disambiguation').text()
      artists.push(myartist)
    end

    @output = artists

  render :search_results


  end
end
