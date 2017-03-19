class Entry < ActiveRecord::Base
	belongs_to :plant
	has_many :pictures
end