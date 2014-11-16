class TribeController < ApplicationController
	before_action :authenticate_user!

	def new
		@tribe = Tribe.new
	end

	def show
		set_tribe
	end

	def create
		@tribe = Tribe.new(tribe_params)
	      if  @tribe.save
	        redirect_to @tribe, notice: "Tribu créée !"
	      else
	        render :new 
	      end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_tribe
      @tribe = Tribe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tribe_params
      params.require(:tribe).permit(:name, :admin_id)
    end
end
