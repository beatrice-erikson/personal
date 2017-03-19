class Species < ActiveRecord::Base
	has_many :cultivars
	belongs_to :genus
end