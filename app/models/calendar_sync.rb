class CalendarSync < ActiveRecord::Base

	belongs_to :user

	validates :google_calendar_id, uniqueness: {scope: :user_id}, presence: true

	def google_client(user)
	    client = Google::APIClient.new(:application_name => 'trybe', :application_version => '0.1.0')
	    client.authorization.client_id = ENV["GOOGLE_APP_ID"]
	    client.authorization.client_secret = ENV["GOOGLE_APP_SECRET"]
	    client.authorization.refresh_token = user.google_refresh_token
	    client.authorization.access_token = user.google_token

	    if client.authorization.refresh_token && client.authorization.expired?
	      client.authorization.fetch_access_token!
	      user.update(google_access_token:client.authorization.access_token)
	    end

	    service = client.discovered_api('calendar', 'v3')
	    result = client.execute(
	      :api_method => service.calendar_list.list,
	      :parameters => {},
	      :headers => {'Content-Type' => 'application/json'})
	    list = JSON.parse(result.data.to_json)
	    items = list["items"]
	    calendar_list = Array.new
	    items.each do |t|
	    	calendar_list << t["id"]
	    end
	    calendar_list
	end

	def fetch_calendar
	    client = Google::APIClient.new(:application_name => 'trybe', :application_version => '0.1.0')
	    client.authorization.client_id = ENV["GOOGLE_APP_ID"]
	    client.authorization.client_secret = ENV["GOOGLE_APP_SECRET"]
	    client.authorization.refresh_token = user.google_refresh_token
	    client.authorization.access_token = user.google_token

	    if client.authorization.refresh_token && client.authorization.expired?
	      client.authorization.fetch_access_token!
	    end

		service = client.discovered_api('calendar', 'v3')
	    result = client.execute(
	      :api_method => service.freebusy.query,
	      :body => JSON.dump({
	      					:timeMin => DateTime.now.to_datetime.rfc3339,
	      					:timeMax => (DateTime.now + 7.days).to_datetime.rfc3339,
	      					:items => [{'id' => google_calendar_id}]
	      				}),
	      :headers => {'Content-Type' => 'application/json'})
	    busy_schedule = JSON.parse(result.data.to_json)["calendars"][google_calendar_id]["busy"]
	end
end
