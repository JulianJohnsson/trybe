class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  	around_filter :append_event_tracking_tags
  	protect_from_forgery with: :exception
  	#before_filter :require_login

  	def mixpanel_distinct_id
    	#current_visitor.id
  	end

  	def mixpanel_name_tag
    	current_user && current_user.email
  	end

	private


  def current_visitor
    @current_visitor ||= Visitor.find(session[:visitor_id]) if session[:visitor_id]
  end
  helper_method :current_visitor
end
