class PagesController < ApplicationController

	def home
		render :home, :layout => 'special'
		track_event("home_page")
	end

end