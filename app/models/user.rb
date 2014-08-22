class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

#pas utilisée dans cette version, voir en desssous
  	def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_create do |user|
		    user.email = auth.info.email
		    user.password = Devise.friendly_token[0,20]
		    #user.name = auth.info.name   # assuming the user model has a name
		    #user.image = auth.info.image # assuming the user model has an image
	  end
	end

	def self.new_with_session(params, session)
    	super.tap do |user|
      		if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        		user.email = data["email"] if user.email.blank?
      		end
    	end
  	end


def facebook_client
   Koala::Facebook::API.new(facebook_token)
end

def self.configure_facebook_user(authorisation_hash)
  user = User.where(:email => authorisation_hash.info.email).first

  unless user
    user = User.create(:email => authorisation_hash.info.email,
                       :first_name => authorisation_hash.extra.raw_info.first_name,
                       :last_name => authorisation_hash.extra.raw_info.last_name,
                       :gender => Gender[authorisation_hash.extra.raw_info.gender.to_sym],
                       :date_of_birth => nil,
                       :location => authorisation_hash.extra.raw_info.hometown.name,
                       :about => authorisation_hash.extra.raw_info.bio,
                       :password => Devise.friendly_token[0,20]
                      )
  end
  user.facebook_token = authorisation_hash.credentials.token
  user.provider = authorisation_hash.provider
  user.uid = authorisation_hash.uid
  user.save
  user
end

def self.find_for_google_oauth2(access_token)
    data = access_token.info
    user = User.where(:email => data.email).first
    
    unless user
        user = User.create(name: data["name"],
	          provider:access_token.provider,
	          email: data["email"],
	          uid: access_token.uid ,
	          password: Devise.friendly_token[0,20],
	        )
   end
   user.google_token = access_token.credentials.token
   user.google_refresh_token = access_token.credentials.refresh_token
   user.provider = access_token.provider
   user.uid = access_token.uid
   user.save
   user
end

def google_client
    client = Google::APIClient.new(:application_name => 'trybe', :application_version => '0.1.0')
    client.authorization.client_id = ENV["GOOGLE_APP_ID"]
    client.authorization.client_secret = ENV["GOOGLE_APP_SECRET"]
    client.authorization.refresh_token = google_refresh_token
    client.authorization.access_token = google_token

    if client.authorization.refresh_token && client.authorization.expired?
      client.authorization.fetch_access_token!
    end

    service = client.discovered_api('calendar', 'v3')
    result = client.execute(
      :api_method => service.calendar_list.list,
      :parameters => {},
      :headers => {'Content-Type' => 'application/json'})
    result

end

end
