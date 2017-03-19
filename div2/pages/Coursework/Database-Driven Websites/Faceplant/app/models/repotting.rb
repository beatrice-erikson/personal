class Repotting < ActiveRecord::Base
	belongs_to :plant
	belongs_to :pot
end