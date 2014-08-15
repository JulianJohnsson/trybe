class AddTokensToUsers < ActiveRecord::Migration
  def change
  	    add_column :users, :facebook_token, :string
    	add_column :users, :google_token, :string
  end
end
