class ChangeCalendars < ActiveRecord::Migration
  def self.up
  	rename_table :calendarsyncs, :calendar_syncs
  end 
  def self.down
  	rename_table :calendar_syncs, :calendarsyncs
  end
end
