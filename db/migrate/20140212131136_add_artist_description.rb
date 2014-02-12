class AddArtistDescription < ActiveRecord::Migration
  def self.up
    add_column :user_artists, :description, :string
  end
  def self.down
    remove_column :user_artists, :description,:string
  end
end

