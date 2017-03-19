class Cultivar < ActiveRecord::Base
	has_many :plants
	belongs_to :species
	delegate :genus, to: :species
end