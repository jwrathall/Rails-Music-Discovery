class ReleasesController < ApplicationController
  require 'settings'
  require 'faraday'
  require 'nokogiri'
  require 'open-uri'

  def index


    @month = Time.now.strftime('%m')
    @year =  Time.now.strftime('%Y')
    @arid = params['id']

    conn_lf = Faraday.new(:url => Settings.last_fm_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    lf = conn_lf.get ''+ '?method=artist.getinfo&mbid=' + params['id'] + '&api_key=' + Settings.last_fm_api + '&format=json'


    myvar = ActiveSupport::JSON.decode(lf.body)
    @band_name =  myvar['artist']['name']
    @on_tour  = myvar['artist']['ontour']

    if myvar['artist']['bio']['placeformed'] != nil?
      @placeformed = myvar['artist']['bio']['placeformed']
    else
      @placeformed = ''
    end

   if myvar['artist']['bio']['formationlist'] != nil?
     if myvar['artist']['bio']['formationlist']['formation'].is_a? Array
       @is_array = true
       date_formed= myvar['artist']['bio']['formationlist']['formation']
     else
       @is_array = false
       date_formed= myvar['artist']['bio']['formationlist']
     end
   else
     date_formed = ''
   end
   @formation = date_formed

    @json_tags = myvar['artist']['tags']['tag']




    @summary =  myvar['artist']['bio']['summary'].html_safe
    if myvar['artist']['bandmembers'] != nil
      @members = myvar['artist']['bandmembers']['member']
    else
      @members = ''
    end



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
 #event_data["data"]["object"]["id"]


  end

  def show
  end
end
#http://musicbrainz.org/ws/2/release/?query=arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46%20AND%20country:us%20AND%20format:CD%20AND%20primarytype:album%20AND%20status:official for some reason some albums are returned with 3 or more entries
#http://musicbrainz.org/ws/2/release/?query=arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46%20AND%20country:us%20AND%20format:CD%20AND%20status:official
#http://localhost:3000/artist/release?band=Deftones&release=Koi+No+Yokan
#http://musicbrainz.org/ws/2/release/?query=release:Koi+No+Yokan%20AND%20arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46%20AND%20country:us%20AND%20format:CD