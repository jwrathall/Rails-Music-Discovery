class IndexController < ApplicationController
  require 'music_brainz'
  def index
    tuesday = Date.today.beginning_of_week(:tuesday).strftime('%Y-%m-%d')
    @response = MusicBrainz.get_new_releases tuesday
    #http://www.lucenetutorial.com/lucene-query-syntax.html for date range searching
    #http://lucene.apache.org/core/2_9_4/queryparsersyntax.html#+
    #might need something like this
    #http://www.musicbrainz.org/ws/2/release/?query=date:2014-03-04+TO+2014-03-11%20and%20country:US%20and%20type:album|ep|
    #http://www.musicbrainz.org/ws/2/release-group/?query=date:2014-03-11+TO+2014-03-04%20and%20country:xw%20and%20type:album
    #help with searching: http://forums.musicbrainz.org/viewtopic.php?pid=22929#p22929
  end

  def get
    @artists = MusicBrainz.search_artists_by_name(params['band'])
    render :search_results
  end
end
