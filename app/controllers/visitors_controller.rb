class VisitorsController < ApplicationController

  	def new
		@visitor = Visitor.new
		render 'visitors/new'
	end

	def create
		@visitor = Visitor.new(secure_params) 
		@application = Application.find 2
		@facebook_post = FacebookPost.new

		if @visitor.valid? && @visitor.save
			session[:visitor_id] = @visitor.id
			@visitor.subscribe
			track_event("signup", email:"#{@visitor.email}")
			#mixpanel_people_set( "email" => "#{@visitor.email}" )
			flash[:notice] = "Signed up #{@visitor.email} successfully."
			@application.update_subscribers
			cookies[:email] = @visitor.email
			redirect_to soon_path
			#render :index
		else
			render :new, :layout => 'special'
		end 
	end

	def index
		@facebook_post = FacebookPost.new
		if session[:visitor_id]
			@visitor = Visitor.find(session[:visitor_id])
		elsif params[:id]
			@visitor = Visitor.find(params[:id])
			session[:visitor_id] = @visitor.id
		else
			redirect_to root_path
		end
	end

	def show
		@user = User.new
		@visitor = Visitor.find(params[:id])
	end

	private
	def set_visitor
      @visitor = Visitor.find(params[:id])
    end
	def secure_params 
		params.require(:visitor).permit(:email)
	end 
end
