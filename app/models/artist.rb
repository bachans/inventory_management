class Artist < ActiveRecord::Base
	has_many :album
	
	validates :name, 	:presence => true
	validates :active_years, 	:presence => true
	validates :biography, 	:presence => true
end
