class ToursController < ApplicationController
  def index
    @mbid = params['id']

    conn_lf = Faraday.new(:url => Settings.last_fm_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn_lf.get ''+ ''+ Settings.get_string('last_fm_get_events') + 'mbid=' + @mbid + '&limit=20&api_key=' + Settings.last_fm_api + '&format=json'

    json = ActiveSupport::JSON.decode(response.body)

    @json = json['events']['event']
    @band_name = json['events']['@attr']['artist']
    @events = json['events']['event']['artists']['artist']

  end
end
