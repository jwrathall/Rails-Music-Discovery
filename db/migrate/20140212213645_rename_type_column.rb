class RenameTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column :user_artists, :type, :artist_type
  end
  def self.down
    # rename back if you need or do something else or do nothing
    # but the word 'type' causes problems
  end
end
