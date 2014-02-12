class CreateUserArtists < ActiveRecord::Migration
  def change
    create_table :user_artists do |t|
      t.integer :user_id
      t.string :mbid
      t.string :name
      t.string :type
      t.string :country_name
      t.string :country_id
      t.string :area_name
      t.string :area_id

      t.timestamps
    end
  end
end
