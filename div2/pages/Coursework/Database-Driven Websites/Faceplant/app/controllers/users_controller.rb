class UsersController < ApplicationController
	before_filter :authorize, :only => [:destroy, :edit]
	def show
		if params[:username]
			@user = User.find_by_username params[:username]
		else
			redirect_to '/'
		end
	end
	def new
		@user = User.new
	end
	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to @user
		else
			render 'new'
		end
	end	
	private
		def user_params
			params.require(:user).permit(:username, :password, :password_confirmation)
		end
end
