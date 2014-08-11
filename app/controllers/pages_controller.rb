class PagesController < ApplicationController

	def home
		render :home, :layout => 'special'
	end

end