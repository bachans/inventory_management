class Customer < ActiveRecord::Base
	has_many :orders
	
	
	validates :first_name, 	:presence => true
	validates :last_name, 	:presence => true
	validates :zip_code, 	:presence => true
	
	
end
