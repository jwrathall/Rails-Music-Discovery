class ReleaseController < ApplicationController
  require 'last_fm'
  def index
    @r = LastFm.get_release(params['artist'],params['release'],params['mbid'])
  end
end
