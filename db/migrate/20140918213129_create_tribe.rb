class CreateTribe < ActiveRecord::Migration
  def change
    create_table :tribes do |t|
    	t.string :name
    	t.string :admin_id
    	t.timestamps
    end
    create_table :users_tribes, id: false do |t|
    	t.belongs_to :users
    	t.belongs_to :tribes
    end
  end
end
