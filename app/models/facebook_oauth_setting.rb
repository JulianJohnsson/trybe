class FacebookOauthSetting < ActiveRecord::Base

	belongs_to :user
	belongs_to :visitor

end
