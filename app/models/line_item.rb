class LineItem < ActiveRecord::Base
	belongs_to :order
	belongs_to :album
	
	def self.new_base_on(album)
		line_item = LineItem.new
		line_item.album = album
		line_item.quantity = 1
		line_item.price = album.price
		return line_item
	end
	
end
