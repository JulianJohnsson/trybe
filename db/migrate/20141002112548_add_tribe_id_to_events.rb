class AddTribeIdToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :tribe_id, :string
  end
end
