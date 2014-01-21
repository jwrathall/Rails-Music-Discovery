class AlbumsController < ApplicationController
  require 'settings'
  require 'faraday'
  require 'nokogiri'
  require 'open-uri'

  def index
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
      r = { :id => release.attribute('id').text(),
            :title => release.xpath('title').text(),
            :release_date => release.xpath('first-release-date').text()
      }
      releases.push(r)
    end

    #this is kinda dumb on my end, I couldn't figure out how to concat the two searches! - seriously, like 3 hours burned

    response = conn.get ''+ Settings.musicbrainz_release_query + params['id'] + '&type=soundtrack'
    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!

    xml.xpath('//release-group-list//release-group').each do |release|
      r = { :id => release.attribute('id').text(),
            :title => release.xpath('title').text(),
            :release_date => release.xpath('first-release-date').text()
      }
      releases.push(r)
    end

    @bandid = releases.sort_by { |hsh| hsh[:release_date] }.reverse

  end

  def show
  end
end
