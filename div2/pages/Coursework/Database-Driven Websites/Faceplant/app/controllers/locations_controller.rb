class LocationsController < ApplicationController
	before_filter :authorize, :only => [:new, :create, :destroy, :edit]
	def index
		if params[:username]
			@user = User.find_by_username(params[:username])
		elsif current_user
			@user = current_user
		else
			redirect_to '/'
		end
	end
	
	def show
		@location = Location.find_by_name(params[:name])
	end
	def new
		@location = Location.new
	end
	def create
		@location = Location.new(location_params)
		if @location.save
			redirect_to '/' + current_user.username
		else
			render 'new'
		end
	end
	def destroy
	end
	private
		def location_params
			params.require(:location).permit(:name, :description).merge(:user_id => current_user.id, :current => true)
		end
end