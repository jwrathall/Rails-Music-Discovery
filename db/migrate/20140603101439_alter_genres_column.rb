class AlterGenresColumn < ActiveRecord::Migration
  #when app was deployed to heroku, the column names were different then development
  #I was unable to track down why, therefor this hack
  def change
    rename_column :genres, :user_artists_id, :user_artist_id
  end
end

