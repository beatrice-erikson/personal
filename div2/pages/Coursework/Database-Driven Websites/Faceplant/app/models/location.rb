class Location < ActiveRecord::Base
	belongs_to :user
	has_many :plants
	validates_uniqueness_of :name, scope: :user_id 
	validates :name, length: { in: 1..16 }, format: { with: /\A(?=.*[[:alpha:]])([[:alnum:]]+)([_\-\.][[:alnum:]]+)*\Z/ }
end