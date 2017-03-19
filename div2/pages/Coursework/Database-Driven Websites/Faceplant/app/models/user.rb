class User < ActiveRecord::Base
	has_secure_password
	include Amistad::FriendModel #https://github.com/raw1z/amistad/wiki/_pages
	
	has_many :locations
	has_many :pots
	has_many :plants, :through => :locations
	has_many :entries, :through => :plants
	has_many :pictues, :through => :entries
	
	validates :username, uniqueness: true, length: { in: 1..16 }, format: { with: /\A(?=.*[[:alpha:]])([[:alnum:]]+)([_\-\.][[:alnum:]]+)*\Z/ }
	validates :password, length: { in: 6..20}, format: { with: /(?=.*[a-z])(?=.*[A-Z]+)(?=.*[0-9]+)(?=.*[\?\-\.\+\*@\$\\\/_])/ }, confirmation: true
end