class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.belongs_to :user_artists
      t.string :tag

      t.timestamps
    end
  end
end
