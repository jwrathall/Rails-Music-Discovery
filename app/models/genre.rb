class Genre < ActiveRecord::Base
  belongs_to :user_artist
  attr_accessible :tag, :user_artist_id
end
