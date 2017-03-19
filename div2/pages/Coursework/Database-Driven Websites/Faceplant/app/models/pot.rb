class Pot < ActiveRecord::Base
	belongs_to :user
	
	has_one :plant
	has_many :repottings
	
	def desc
		width.to_s + '" ' + color + " " + material + " pot"
	end
end