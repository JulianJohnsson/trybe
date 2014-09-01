class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
	   	t.string :type
	   	t.string :google_calendar_id
	    t.string :user_id

	    t.timestamps
    end
  end
end
