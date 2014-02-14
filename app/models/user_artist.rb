class UserArtist < ActiveRecord::Base
   has_many :genres
   accepts_nested_attributes_for :genres
   attr_accessible  :user_id, :mbid, :name, :artist_type, :country_name, :country_id, :area_name, :area_id, :description,:genres
   def artist_exists(user_id)
      user = user_id
      artist_count = UserArtist.where('user_id = ? AND mbid = ?',user, mbid).select('mbid').count

     if artist_count > 0
       return true
     else
       return false
     end

   end
end
