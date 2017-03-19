class PotsController < ApplicationController
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
		@pot = Pot.find(params[:id])
	end
	def new
		@pot = Pot.new
	end
	def create
		@pot = Pot.new(pot_params)
		if @pot.save
			redirect_to '/' + current_user.username
		else
			render 'new'
		end
	end
	def destroy
	end
	private
		def pot_params
			params.require(:pot).permit(:width, :height, :color, :material).merge(:user_id => current_user.id, :owned => true)
		end
end