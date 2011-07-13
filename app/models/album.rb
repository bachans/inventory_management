class Album < ActiveRecord::Base

	
	belongs_to :artist
	has_many :line_items
  has_many :cart_items
  has_many :private_orders
	
	
	validates :title, 	:presence => true,
						:length => { :minimum => 3 },
						:uniqueness => {:case_sensitive => false}
						
	validates :release_date, 	:presence => true
	
	validates :artist, :presence => true

	
	
end
