class FriendshipsController < ApplicationController
	before_filter :authorize
	def create
		@friend = User.find(params[:friend_id])
		if current_user.pending_invited_by.pluck(:id).include? @friend.id
			@current_user.approve @friend
			redirect_to '/'
		else
			@current_user.invite @friend
			redirect_to '/' + @friend.username
		end
	end
	def destroy
		@friend = User.find(params[:friend_id])
		@current_user.remove_friendship @friend
		redirect_to '/' + @friend.username
	end
end