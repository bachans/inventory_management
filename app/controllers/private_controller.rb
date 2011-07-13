class PrivateController < ApplicationController
 
    # @desc: listing the albums for registered user
    # have layout
    def list
      
        # get all albums in asc order of their creating date
        @albums = Album.all(:order=>'created_at DESC')
    end #end of list
  
  
    # @desc: add to cart_items table
    # dont have layout
    def add_private_cart
      
        # get album from album_id
        @album = Album.find(params[:id])
        # get the user id from session
        @user_id = session[:id]
        
        # get the item from cart_item table
        find_cart = CartItem.find(:all, :conditions => {:user_id => @user_id , :album_id => @album})
        
        # if any row fetched(should ve only one row) 
        if find_cart.any?
          
            # get the active record
            cart_item = find_cart[0]
            # increment the quantity of that record
            quantity = cart_item.quantity + 1
            
            # update the record
            if cart_item.update_attributes(:quantity => quantity)
                
                # redirect to show cart
                redirect_to privateshowcart_path
            end
        
        # if no row fetchd(i.e. a new item)
        else
        
          # just add to cart against to the user
          cart = CartItem.new(:user_id =>@user_id,:album_id => @album.id, :quantity => 1)
          
              # save the record
              if cart.save
                redirect_to privateshowcart_path
              else
                redirect_to privatealbums_path
              end
        
        end
      
    end # end of add_private_cart
  
  # @desc: show the items from cart_item table
  # have layout
  def private_showcart
     @cart_items = CartItem.find(:all, :conditions => {:user_id => session[:id]}, :order => 'id asc')
  end
 
  # @desc: remove each item from cart_item table
  # dont have layout
 def remove_private_item
   album_id = params[:id]
   user_id = session[:id]
   
   find_cart = CartItem.find(:all, :conditions => {:user_id => user_id , :album_id => album_id})
   
   if find_cart.any?
     cart_item = find_cart[0]
     
     if cart_item.quantity > 1
        quantity = cart_item.quantity - 1
        
        if cart_item.update_attributes(:quantity => quantity)
          redirect_to privateshowcart_path
        end
     else
        cart_item.destroy 
        redirect_to privateshowcart_path
    end
    
   else 
      redirect_to privatealbums_path
   end
   
 end
 
 # @desc: empty cart_item table for that user
 # dont have layout
 def empty_private_cart
   user_id = session[:id]
   find_cart = CartItem.find(:all, :conditions => {:user_id => user_id})
   
   find_cart.each do |cart_item|
     cart_item.destroy 
   end
   
   redirect_to privatealbums_path
 end
 
    # desc: checkout form 
    def private_checkout
      user_id = session[:id]
      
      invoice_arr = Invoice.find(:all, :conditions => {:user_id => user_id, :status => 'pending'})
      
      if not invoice_arr.any?
          invoice_number = "#{Time.now.strftime("%Y%m%d%H%M%S")}#{user_id}"
          status = 'pending'
          invoice = Invoice.new(:invoice_number => invoice_number, :user_id => user_id, :status => status)
          
          if invoice.save
              redirect_to showprivatecheckout_path
          else
              redirect_to privateshowcart_path
          end
      end
      
    end
    
    def show_private_checkout
        invoice_arr = Invoice.find(:all, :conditions => {:user_id => session[:id], :status => 'pending'})
        
        if invoice_arr.any?
            @invoice = invoice_arr[0]
            @cart_items = CartItem.find(:all, :conditions => {:user_id => session[:id]}, :order => 'id asc')
        else
            redirect_to privateshowcart_path
        end
          
    end
    
    def save_private_order
        invoice_arr = Invoice.find(:all, :conditions => {:user_id => session[:id], :status => 'pending', :invoice_number => params[:invoice]})
        
        if invoice_arr.any?
            invoice_number = params[:invoice]
            cart_items = CartItem.find(:all, :conditions => {:user_id => session[:id]}, :order => 'id asc')
            sum_price = 0
            price = 0
            
            for item in cart_items
                album_id = item.album_id
                quantity = item.quantity
                price = item.album.price * quantity
                sum_price += item.album.price
                
                private_order = PrivateOrder.new(:invoice_number => invoice_number, :album_id => album_id, :quantity => quantity, :price => price)
                
                private_order.save
                item.destroy
            end
            
            invoice = invoice_arr[0]
            invoice.update_attributes(:status => 'paid')
            
            redirect_to "/privatereport/#{invoice.invoice_number}"
        end
    end
    
    def private_report
        x = params[:invoice]
        @invoice_report = Invoice.find_by_invoice_number(x)
        
        if not @invoice_report.nil?
            user_id = @invoice_report.user_id
            
            if user_id == session[:id]
                @invoice_number = @invoice_report.invoice_number
                @private_orders = PrivateOrder.find(:all, :conditions => {:invoice_number => x})
                Notifier.welcome.deliver
            end
            
        end
       
        
    end

end
