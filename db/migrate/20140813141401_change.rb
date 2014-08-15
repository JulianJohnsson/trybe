class Change < ActiveRecord::Migration
  def self.up
  	rename_table :users, :oldusers
  end 
  def self.down
  	rename_table :oldusers, :users
  end
end
