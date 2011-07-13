class AlbumsController < ApplicationController
  before_filter :check_admin
	# GET /albums
	# GET /albums.xml
	def index

		if signed_in?
			@albums = Album.all(:order => 'created_at DESC')
		else
			redirect_to root_path
		end
	end

	# GET /albums/1
	# GET /albums/1.xml
	def show

		if signed_in?
			@album = Album.find(params[:id])
		else
			redirect_to root_path
		end
	end

	# GET /albums/new
	# GET /albums/new.xml
	def new
		if signed_in?
			@album = Album.new
			@artists = Artist.all
		else
			redirect_to root_path
		end
	end
	# POST /albums
	# POST /albums.xml
	def create
	
		if signed_in?
			@album = Album.new(params[:album])

			if @album.save
				redirect_to albums_path
			else
				render 'new'
			end
		else
			redirect_to root_path
		end
	end

  # GET /albums/1/edit
	def edit
		if signed_in?
			@album = Album.find(params[:id])
		else
			redirect_to root_path
		end
	end

  

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to(@album, :notice => 'Album was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(albums_url) }
      format.xml  { head :ok }
    end
  end
  private
    def check_admin
      if not session[:user_type] == 'admin'
          redirect_to root_path
      end
    end
end

