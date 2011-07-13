class PublicController < ApplicationController
  
  before_filter :check_session
  
  #
  def list
  	@albums = Album.find(:all, :order => 'created_at DESC')
  end
	
	#
  def showalbum
		@album = Album.find(params[:id])
	end
	
	#
  def add_to_cart
		# find the album by id
		album = Album.find(params[:id])
		
		if not session[:cart]
			@cart = Cart.new
		else
			@cart = session[:cart]
		end 
		# add the album to cart
		@cart.add_album(album)
		session[:cart] = @cart
		redirect_to(:action => 'show_cart')
	end
	
	#
  def show_cart
		@cart = session[:cart]
	end
	
	#
  def checkout
		@cart = session[:cart]
		@customer = Customer.new
	end
	
	#
  def empty_cart
		if session[:cart]
			@cart = session[:cart]
			@cart.empty_all_items
		end
		
		flash[:notice] = 'Your cart is now empty'
		redirect_to list_path
	end
	
	#
  def remove_item
		if session[:cart]
			@cart = session[:cart]
			album = Album.find(params[:id])
			@cart.remove_item(album)
		end
		redirect_to showcart_path
  end
  
  #
  
  def save_order
     
    c = Customer.find(:all,:conditions => {:first_name => params[:first_name], :last_name => params[:last_name], :zip_code => params[:zip_code]})
    
    if c.any?
      @customer = c[0]
    else  
      @customer = Customer.new(:first_name => params[:first_name], :last_name => params[:last_name], :zip_code => params[:zip_code])
    end
    o = Order.all(:order=>'id DESC')
    if o.any?
      o_invoice = "#{Time.now.strftime("%Y%m%d%H%M%S")}_#{o[0].id+1}"
    else
      o_invoice = "#{Time.now.strftime("%Y%m%d%H%M%S")}_1"
    end
    @order = Order.new
    @order.invoice = o_invoice
    @cart = session[:cart]
    @order.line_items << @cart.items
    @customer.orders << @order
    
    if @customer.save
		  @cart.empty_all_items
      session[:invoice] = o_invoice
      redirect_to report_path
    else
      render :action => "new"
    end

  end
  
	def report
		@invoice = session[:invoice]
    @order = Order.find_by_invoice(@invoice)
    @customer = @order.customer
	   @line_item = @order.line_items
	end

	private
	
		def find_or_create_cart
			session[:cart] ||= Cart.new
	end
  
  # checking the session in public controller
  # accessibility : private
  # return void
  def check_session
    
    # check session for cart exists?
    if session[:cart]
      
      # if session exists then assign it to @cart
      @cart = session[:cart]
      # store the @cart.items array in a variable
      @cart_items = @cart.items
      
      # check the @cart_items length greater than two
      if @cart_items.length > 2
        # set the @cart_flag to 1
        session[:cart_flag] = 1
      else
        # set the cart_flag to 0
        session[:cart_flag] = 0
      end
      
    else
      session[:cart_flag] = 0
    end
    
  end
  
end
