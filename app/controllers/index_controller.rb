class IndexController < ApplicationController
  require 'faraday'

  def new

  end
  def index

  end

  def search

    #http://musicmachinery.com/music-apis/
    search_criteria = params['band']
    url =  DevMusicCom::Settings.get_string_setting('music_brainz_url')


=begin
    conn = Faraday.new(:url => url) do |faraday|
       faraday.request  :url_encoded             # form-encode POST params
       faraday.response :logger                  # log requests to STDOUT
       faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
     end
    response = conn.get '/ws/2/artist/?query=artist:"' + search_criteria+'"'
    response.body

    result = response.body #JSON.parse(response.body)
=end
   render xml: url, status: 201
  end
end
