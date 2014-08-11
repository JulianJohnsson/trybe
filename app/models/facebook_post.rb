class FacebookPost < ActiveRecord::Base
	has_no_table

	column :message, :string
	validates_presence_of :message

end
