class PlantsController < ApplicationController
	before_filter :authorize, :only => [:new, :create, :destroy, :edit]
	def index
		if params[:username]
			@user = User.find_by_username params[:username]
		elsif current_user
			@user = User.find_by_username(current_user.username)
		else
			redirect_to '/login'
		end
		@locations = @user.locations
	end
	def new
		@plant = Plant.new
		@genuses = Genus.all
		@specieses = Species.where("genus_id = ?", @genuses.first.id)
		@cultivars = Cultivar.all
		@pots = current_user.pots.where(owned: true).joins("LEFT OUTER JOIN plants ON plants.pot_id = pots.id").where("plants.id IS null")
	end
	def create
		@pots = current_user.pots.where(owned: true).joins("LEFT OUTER JOIN plants ON plants.pot_id = pots.id").where("plants.id IS null")
		@plant = Plant.new(plant_params)
		if current_user.pots.find_by_id(@plant.pot_id) && current_user.locations.find_by_id(@plant.location_id)
			if @plant.save
				redirect_to '/' + current_user.username
			else
				render 'new'
			end
		else
			render 'new'
		end
	end
	def destroy
	end
	def update_specieses
		@specieses = Species.where("genus_id = ?", params[:genus_id])
		respond_to do |format|
			format.js
		end
	end
	private
		def plant_params
			params.require(:plant).permit(:name, :obtained, :description, :location_id, :pot_id, :cultivar_id).merge(:alive => true)
		end
end