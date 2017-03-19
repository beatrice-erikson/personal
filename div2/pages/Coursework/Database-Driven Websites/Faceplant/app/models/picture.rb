class PictureValidator < ActiveModel::Validator
	def validate(record)
		if record.plant.pictures.pluck(:filepath).include? record.filepath
			record.errors[:filepath] << "Filename already in use for this plant"
		end
	end
end

class Picture < ActiveRecord::Base
	include ActiveModel::Validations
	belongs_to :entry
	delegate :plant, to: :entry
	validates_with PictureValidator
end