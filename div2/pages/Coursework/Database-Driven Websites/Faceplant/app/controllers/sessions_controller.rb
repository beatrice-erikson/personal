class SessionsController < ApplicationController
	def new
	end
	
	def create
		user = User.find_by_username(params[:username])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to '/'
		else
			if user
				@loginerror = "Invalid password"
			else
				@loginerror = "Invalid username"
			end
			render 'new'
		end
	end
	
	def destroy
		session[:user_id] = nil
		redirect_to '/login'
	end

end