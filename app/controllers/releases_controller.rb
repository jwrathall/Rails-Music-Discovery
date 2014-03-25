class ReleasesController < ApplicationController
  require 'settings'
  require 'faraday'
  require 'nokogiri'
  require 'open-uri'
  require 'last_fm'

  def index
     #http://musicbrainz.org/ws/2/artist/?query=arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46&fmt=json

    @month = Time.now.strftime('%m')
    @year =  Time.now.strftime('%Y')

    @artist = LastFm.get_artist_detail_by_id(params['id'])

=begin
    <%@formation.each_with_index do |date, i| %>
              <%if @is_array%>
    <%if date['yearto'] == ''%>
    <%yearto = 'present'%>
    <%else%>
                      <%yearto = date['yearto']%>
    <%end%>
    <%=date['yearfrom']%> - <%=yearto%> <%=', ' unless i == @formation.length-1%>
    <%else%>
                  <%if date[1]['yearto'] == ''%>
  <%yearto = 'present'%>
      <%else%>
                      <%yearto = date[1]['yearto']%>
  <%end%>
  <%=date[1]['yearfrom']%> - <%=yearto%>
  <%end%>
<%end%>
=end

    #replace below with this: http://musicbrainz.org/ws/2/release-group/?query=arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46&fmt=json


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