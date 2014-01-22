class AlbumsController < ApplicationController
  require 'settings'
  require 'faraday'
  require 'nokogiri'
  require 'open-uri'

  def index

    #TODO: get band info from last.fm, need api key, pass in band id
    @month = Time.now.strftime('%m')
    @year =  Time.now.strftime('%Y')
    @band_name = params['name']
    conn = Faraday.new(:url => Settings.musicbrainz_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.get ''+ Settings.musicbrainz_release_query + params['id'] + '&type=album'
    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!
    releases = Array.new
    xml.xpath('//release-group-list//release-group').each do |release|
      date = release.xpath('first-release-date').text().to_s
      unless date.empty?
        rel_month = date[5..6]
        rel_year = date[0..3]
      else
        rel_year = ''
      end
      r = { :id => release.attribute('id').text(),
            :type => release.attribute('type').text(),
            :title => release.xpath('title').text(),
            :release_month => rel_month,
            :release_year => rel_year
      }
      releases.push(r)
    end

    #this is kinda dumb on my end, I couldn't figure out how to concat the two searches! - seriously, like 3 hours burned

    response = conn.get ''+ Settings.musicbrainz_release_query + params['id'] + '&type=ep'
    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!

    xml.xpath('//release-group-list//release-group').each do |release|
      date = release.xpath('first-release-date').text().to_s
      unless date.empty?
        rel_month = date[5..6]
        rel_year = date[0..3]
      else
        rel_year = ''
      end
      r = { :id => release.attribute('id').text(),
            :type => release.attribute('type').text(),
            :title => release.xpath('title').text(),
            :release_month => rel_month,
            :release_year => rel_year
      }
      releases.push(r)
    end

    @releases = releases.sort_by { |hsh| hsh[:release_year] || '0'}.reverse


#    conn_lf = Faraday.new(:url => Settings.last_fm_url) do |faraday|
#      faraday.request  :url_encoded             # form-encode POST params
#      faraday.response :logger                  # log requests to STDOUT
#      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
#    end
#
#    releases.each do |release|
#=begin
#      conn_lf.get do |rel|                           # GET http://sushi.com/search?page=2&limit=100
#        rel.url '?method=album.getbuylinks&artist=', :page => band_name
#        rel.params['album'] = release['name'],
#        rel.params['country'] = 'us',
#        rel.params['api_key'] = Settings.last_fm_api.to_s,
#        rel.params['format'] = 'json'
#      end
#=end
#
#      last_fm_album = conn_lf.get '?method=album.getbuylinks&artist=' + band_name + '&album=' + release[:title].to_s + '&country=us&api_key=' + Settings.last_fm_api.to_s + '&format=json'
#
#    end
#    @somevar = var
    #event_data["data"]["object"]["id"]


  end

  def show
  end
end
