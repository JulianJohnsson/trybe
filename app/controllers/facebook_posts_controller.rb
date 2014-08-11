class FacebookPostsController < ApplicationController
	def new
		@facebook_post = FacebookPost.new
	end

	def index
		unless current_visitor.facebook_oauth_setting
			@oauth = Koala::Facebook::OAuth.new(ENV['FACEBBOK_APP_ID'], ENV['FACEBBOK_APP_SECRET'], ENV['FACEBBOK_CALLBACK_URL'])
			session["oauth_obj"] = @oauth
			redirect_to @oauth.url_for_oauth_code
		else
			redirect_to '/post'
		end
	end

	def callback
		unless current_visitor.facebook_oauth_setting
			@oauth = session["oauth_obj"]
			FacebookOauthSetting.create({:access_token => @oauth.get_access_token(params[:code]), :visitor_id => current_visitor.id})
			redirect_to "/post"
		else
			redirect_to "/index"
		end
	end

	def create
		@facebook_post = FacebookPost.new(secure_params)
		session[:facebook_post] = @facebook_post
		redirect_to "/post"
	end

	def post
		@facebook_post = session[:facebook_post]
		if current_visitor.facebook_oauth_setting
			if @facebook_post.valid?
				@graph = Koala::Facebook::API.new(current_visitor.facebook_oauth_setting.access_token)
				@graph.put_wall_post(@facebook_post.message, 
					:name => "rassembles ta tribu et organises facilement tes soirées entre amis.", 
					:link =>"http://www.trybe-app.com")
				Rails.logger.info("Message posté: #{@facebook_post.message}")
				flash[:notice] = "Message envoyé ! Merci pour le coup de pouce ;-)"
				render :show
			else
				flash[:alert] = "Message invalide !"
				render new
			end
		else
			redirect_to "/index"
		end
	end

	def show
		@facebook_post = current_visitor.facebook_post
		@visitor = current_visitor
	end

	private

	def secure_params 
		params.require(:facebook_post).permit(:message)
	end 
end