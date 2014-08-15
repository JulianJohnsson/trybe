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


def facebook_client(access_token)
   Koala::Facebook::API.new(access_token)
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
  user.remember_me!
  user
end

def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        	return registered_user
      else
        	user = User.create(name: data["name"],
	          provider:access_token.provider,
	          email: data["email"],
	          uid: access_token.uid ,
	          password: Devise.friendly_token[0,20],
	        )
      	end
   end
end

end
