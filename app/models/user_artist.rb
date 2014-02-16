class UserArtist < ActiveRecord::Base
   has_many :genres
   accepts_nested_attributes_for :genres
   attr_accessible  :user_id, :mbid, :name, :artist_type, :country_name, :country_id, :area_name, :area_id, :description,:genres

   before_save :if_exists

   def if_exists
     #TODO: add in user id as part of query
      artist_count =  UserArtist
                      .where('mbid = ?', mbid)
                      .select('mbid')
                      .count
     if artist_count != 0
       return false
     else
       return true
     end

   end
end
