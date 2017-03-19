class PlantValidator < ActiveModel::Validator
	def validate(record)
		if record.user.plants.pluck(:name).include? record.name
			record.errors[:name] << "is already being used for another plant"
		end
	end
end

class Plant < ActiveRecord::Base
	include ActiveModel::Validations
	belongs_to :location
	belongs_to :pot
	belongs_to :cultivar
	delegate :species, to: :cultivar
	delegate :genus, to: :species
	delegate :user, to: :location
	
	has_many :entries
	has_many :pictures, :through => :entries
	has_many :repottings
	has_many :waterings
	
	has_one :displaypicture, -> { where(is_disp: true) }, :class_name => 'Picture'
	validates :name, length: { in: 1..16 }, format: { with: /\A(?=.*[[:alpha:]])([[:alnum:]]+)([_\-\.][[:alnum:]]+)*\Z/ }
	validates :location, presence: true
	validates :pot, presence: true
	validates :cultivar, presence: true
	validates_uniqueness_of :pot_id, :message => "already contains a plant"
	validates_with PlantValidator
end