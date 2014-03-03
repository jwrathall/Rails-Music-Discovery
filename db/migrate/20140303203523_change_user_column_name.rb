class ChangeUserColumnName < ActiveRecord::Migration
  def self.up
    rename_column :users, :hash, :hash_password
  end
  def self.down
    #not recommended to migrate down, 'hash' is a reserved word
  end
end
