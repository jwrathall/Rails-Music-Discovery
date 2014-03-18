class UserArtist < ActiveRecord::Base
   has_many :genres, :dependent => :destroy
   accepts_nested_attributes_for :genres
   attr_accessible  :user_id, :mbid, :name, :artist_type, :country_name, :country_id, :area_name, :area_id, :description,:genres

   before_save :if_exists

   def if_exists
      artist_count =  UserArtist
                      .where('mbid = ? AND user_id = ?', mbid, user_id)
                      .select('mbid')
                      .count
     if artist_count != 0
       errors.add(:message, 'Artist already exists')
       return false
     else
       return true
     end
   end
  def self.get_by_mbid(id)
    UserArtist.includes(:genres).where('mbid = ?',id).first()
  end
end
