class Init < ActiveRecord::Migration
  def change
  	create_table :users do |t|
      t.string :name,            :null => true
      t.string :email,            :null => false
      t.string :crypted_password, :null => false
      t.string :salt,             :null => false

      t.timestamps
    end
	create_table :visitors do |t|
      t.string :email

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
