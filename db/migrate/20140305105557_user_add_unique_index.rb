class UserAddUniqueIndex < ActiveRecord::Migration
  def self.up
    add_index(:users, [:username], :unique => true)
  end
  def self.down
    remove_index(:users, column: username)
  end
end
