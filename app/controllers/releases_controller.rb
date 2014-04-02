class ReleasesController < ApplicationController
  require 'last_fm'

  def index
    @month = Time.now.strftime('%m')
    @year =  Time.now.strftime('%Y')

    @artist = LastFm.get_artist_detail_by_id(params['id'])
    @releases = MusicBrainz.get_release_groups(params['id'])
  end

  def show
  end
end
#http://musicbrainz.org/ws/2/artist/?query=arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46&fmt=json
#replace below with this: http://musicbrainz.org/ws/2/release-group/?query=arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46&fmt=json
#http://musicbrainz.org/ws/2/release/?query=arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46%20AND%20country:us%20AND%20format:CD%20AND%20primarytype:album%20AND%20status:official for some reason some albums are returned with 3 or more entries
#http://musicbrainz.org/ws/2/release/?query=arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46%20AND%20country:us%20AND%20format:CD%20AND%20status:official
#http://localhost:3000/artist/release?band=Deftones&release=Koi+No+Yokan
#http://musicbrainz.org/ws/2/release/?query=release:Koi+No+Yokan%20AND%20arid:7527f6c2-d762-4b88-b5e2-9244f1e34c46%20AND%20country:us%20AND%20format:CD