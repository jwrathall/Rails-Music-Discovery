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
      myartist.name = artist.child().text()
      myartist.id = artist.attribute('id')
      myartist.country_id = artist.xpath('area/@id')
      myartist.country_name = artist.xpath('area/name').text()
      myartist.area_id = artist.xpath('begin-area/@id')
      myartist.area_name =artist.xpath('begin-area/name').text()
      myartist.start = artist.xpath('life-span/begin').text()
      if artist.xpath('life-span/end').text().to_s != ''
        myartist.stop = artist.xpath('life-span/ended').text()
      else
        myartist.stop = 'stop'
      end

      @doc = artist.xpath('disambiguation').text()
      artists.push(myartist)
    end

    @output = artists
   #obj = Hash.from_xml(response.body).to_json
   #json = ActiveSupport::JSON.decode(obj)
   #
   #
   # @xml = json
    #@doc = val
    #@doc = xml.xpath ('//metadata//artist/name/text()')
    #@doc = xml.xpath ('/artist-list/[@ext:score]')
    #xml_dom.xapth '//.' # returns all element nodes
    #xml_dom.xpath '/atom:feed', 'atom' => 'http://www.w3.org/2005/Atom' # returns root node
    #xml_dom.xpath '//atom:entry', 'atom' => 'http://www.w3.org/2005/Atom' # returns 4 entry nodes
    #xml_dom.xpath '//media:group', 'media' => 'http://search.yahoo.com/mrss/' # returns 4 the media:group nodes



   #render xml: xml, status: 201
  render :search_results


  end
end
