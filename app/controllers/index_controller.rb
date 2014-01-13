class IndexController < ApplicationController
  require 'faraday'
  require 'nokogiri'
  require 'open-uri'
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

   # result = response.body #JSON.parse(response.body)
    #https://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet
    #http://stackoverflow.com/questions/2895009/nokogiri-parsing-rackspace-return-using-xpath-in-rails
    #http://stackoverflow.com/questions/4690737/nokogiri-xpath-namespace-query
    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!
    #xml.xpath('//blarg:artist', {'blarg' => 'urn:xml:metadata'}).each do |name|
    #  puts name.text
    #end
    @doc = xml.xpath('/metadata/artist-list//artist//@id')   #http://www.w3schools.com/xpath/xpath_syntax.asp
    #@doc = xml.css('artist')
    #@doc = doc#.xpath("//artist-list ")

   #render xml: xml, status: 201
  render :search_results
  end
end
