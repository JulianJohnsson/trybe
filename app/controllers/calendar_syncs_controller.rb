class CalendarSyncsController < ApplicationController
	
	before_action :authenticate_user!

	def new
		@user = current_user
		@calendar_sync = CalendarSync.new
		@calendar_list = @calendar_sync.google_client(current_user)
	end

	def show
		set_calendar_sync
		@busy_schedule = @calendar_sync.fetch_calendar
	end

	def index
		@calendar_syncs = current_user.calendar_syncs
	end

	def create
		@user = current_user
    	@calendar_sync = CalendarSync.new(calendar_sync_params)

	      if  @calendar_sync.save
	        redirect_to @calendar_sync, notice: "L'agenda est en cours de synchronisation"
	      else
	        render :new 
	      end
	end

	def destroy
		@calendar_sync.destroy
    	respond_to do |format|
	      format.html { redirect_to calendar_syncs_url, notice: 'Le calendrier a été supprimé' }
	      format.json { head :no_content }
	    end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_sync
      @calendar_sync = CalendarSync.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_sync_params
      params.require(:calendar_sync).permit(:type, :google_calendar_id, :user_id)
    end

end