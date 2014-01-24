class ReleaseController < ApplicationController
  def index
    @release_name = params['release']
    @band_name = params['band']
  end
end
