class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, limit: 120
      t.string :password, limit: 25
      t.string :salt
      t.string :hash

      t.timestamps
    end
  end
end
