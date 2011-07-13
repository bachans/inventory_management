class PrivateOrdersController < ApplicationController
  # GET /private_orders
  # GET /private_orders.xml
  def index
    @private_orders = PrivateOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @private_orders }
    end
  end

  # GET /private_orders/1
  # GET /private_orders/1.xml
  def show
    @private_order = PrivateOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @private_order }
    end
  end

  # GET /private_orders/new
  # GET /private_orders/new.xml
  def new
    @private_order = PrivateOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @private_order }
    end
  end

  # GET /private_orders/1/edit
  def edit
    @private_order = PrivateOrder.find(params[:id])
  end

  # POST /private_orders
  # POST /private_orders.xml
  def create
    @private_order = PrivateOrder.new(params[:private_order])

    respond_to do |format|
      if @private_order.save
        format.html { redirect_to(@private_order, :notice => 'Private order was successfully created.') }
        format.xml  { render :xml => @private_order, :status => :created, :location => @private_order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @private_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /private_orders/1
  # PUT /private_orders/1.xml
  def update
    @private_order = PrivateOrder.find(params[:id])

    respond_to do |format|
      if @private_order.update_attributes(params[:private_order])
        format.html { redirect_to(@private_order, :notice => 'Private order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @private_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /private_orders/1
  # DELETE /private_orders/1.xml
  def destroy
    @private_order = PrivateOrder.find(params[:id])
    @private_order.destroy

    respond_to do |format|
      format.html { redirect_to(private_orders_url) }
      format.xml  { head :ok }
    end
  end
end
