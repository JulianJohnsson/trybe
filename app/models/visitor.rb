class Visitor < ActiveRecord::Base
	#has_one :facebook_oauth_setting

	validates_presence_of :email
	validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

	def subscribe
		mailchimp = Gibbon::API.new
		Gibbon::API.lists.interest_groupings(:id => ENV['MAILCHIMP_LIST_ID'])
		#@merge_vars = { :GROUPINGS => [{:name => "INTEREST", :groups => [self.interest]}] }
		result = mailchimp.lists.subscribe({
			:id => ENV['MAILCHIMP_LIST_ID'],
			:email => {:email => self.email},
			#:merge_vars => @merge_vars,
			:double_optin => false,
			:update_existing => true,
			:send_welcome => true
		})
		Rails.logger.info("Subscribed #{self.email} to Mailchimp in #{self.interest}") if result
	end

end
