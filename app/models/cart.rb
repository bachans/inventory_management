#class Cart < ActiveRecord::Base
#though it doesnt have any connection to database
class Cart
	#attr_accesor -> makes those value can be read and written outside of the class through object
	#As we dont need any value to be written only to be read
	attr_reader :items, :total_price
	 
	def initialize
		@items = []
		@total_price =0.0
	end
	
	# desc : adding item to album
	def add_album(album)
	
		#check whther the item is in that cart or not
		existing_item = @items.find{|item| item.album.id == album.id}
		
		if existing_item
			existing_item.quantity += 1
			existing_item.price += album.price
		else
			# line_item is reach join betwn albums and order
			# without creating the instance of line item, just call its function
			#it returns the object of line_item(quantity, ptice,)
			line_item = LineItem.new_base_on(album)
			@items << line_item
		end
		@total_price += album.price
	end	
	
	def empty_all_items
		@items = []
		@total_price =0.0
	end
	
	def remove_item(album)
		#check whther the item is in that cart or not
		existing_item = @items.find{|item| item.album.id == album.id}
		
		if existing_item && existing_item.quantity > 1
			existing_item.quantity -= 1
      existing_item.price -=  album.price
		else
			@items.delete(existing_item)
		end
		
		@total_price -= album.price
	end
	
end
