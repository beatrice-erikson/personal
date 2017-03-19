class Genus < ActiveRecord::Base
	has_many :species
	has_many :cultivars, :through => :species
end