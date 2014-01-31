class ToursController < ApplicationController
  require 'event'
  require 'venue'
  def index
    @mbid = params['id']

    conn_lf = Faraday.new(:url => Settings.last_fm_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn_lf.get ''+ ''+ Settings.get_string('last_fm_get_events') + 'mbid=' + @mbid + '&limit=20&api_key=' + Settings.last_fm_api + '&format=json'

    json = ActiveSupport::JSON.decode(response.body)

    events = json['events']['event']
    @band_name = json['events']['@attr']['artist']
    @json = events
    artist_events = Array.new()
    events.each do |evt|
      event = Event.new()
      event.date = evt['startDate']
      artists = Array.new()
      if evt['artists']['artist'].is_a?(Array) #more than one item
        evt['artists']['artist'].each do |a|
          artists.push(a)
        end
      else
         artists.push(evt['artists']['artist'])
      end
      event.artists = artists

      venue = Venue.new()
      if evt['venue']['name'].nil?
        venue.name = 'not available'
      else

        venue.name = evt['venue']['name']
      end

      venue.city = evt['venue']['location']['city']
      venue.country = evt['venue']['location']['country']
      venue.street = evt['venue']['location']['street']
      venue.postal_code = evt['venue']['location']['postalcode']
      venue.geo_location = {:lat => evt['venue']['location']['geo:point']['geo:lat'],:long => evt['venue']['location']['geo:point']['geo:long']}
      event.venue = venue


      artist_events.push(event)
    end
    @events = artist_events



  end
end

#"location": {
#    "geo:point": {
#    "geo:lat": "",
#    "geo:long": ""
#
#
#
#
#   venue.geo_location = {:lat => evt['venue']['location']['geo:point']['geo:lat'],:long => evt['venue']['location']['geo:point']['geo:long']}
# },