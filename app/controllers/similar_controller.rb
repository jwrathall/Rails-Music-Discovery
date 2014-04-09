class SimilarController < ApplicationController
  def index
    @artist = LastFm.get_similar_artists(params['id'])
  end
end
