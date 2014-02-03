class ReleaseController < ApplicationController
  def index
    @release_name = params['release']
    @artist_name = params['artist']

    conn_lf = Faraday.new(:url => Settings.last_fm_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end


    response = conn_lf.get ''+ Settings.get_string('last_fm_release_info') + 'artist=' + @artist_name + '&album=' + @release_name + '&api_key=' + Settings.last_fm_api + '&format=json'

    @json = ActiveSupport::JSON.decode(response.body)
  end
end
