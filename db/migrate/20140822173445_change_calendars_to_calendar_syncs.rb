class ChangeCalendarsToCalendarSyncs < ActiveRecord::Migration
  def self.up
  	rename_table :calendars, :calendarsyncs
  end 
  def self.down
  	rename_table :calendarsyncs, :calendars
  end
end
