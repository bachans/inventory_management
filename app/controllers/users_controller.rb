class UsersController < ApplicationController
	
	# GET /users/new
	# GET /users/new.xml
	def new
		if not signed_in?
			
			@user = User.new
		else
			redirect_to home_path
		end
	end
	
	# POST /users
	# POST /users.xml
	def create
	
		if not signed_in?
			@user = User.new(params[:user])

			if verify_recaptcha(request.remote_ip, params)[:status] == 'false'
			
				# render to the new action of the users controller.
				@title = "Sign up"
				render 'new'
			else
				if @user.save
					
					#sign_in @user
					# Handle a successful save.
					flash[:success] = "Now you can login to the Sample App!"
					#session[:host] = request.remote_ip
					#redirect_to @user
					redirect_to root_path
				else
					# render to the new action of the users controller.
					@title = "Sign up"
					render 'new'
				end
			end
		else
			redirect_to home_path
		end
		
	end
	
	
	# GET /users/1
	# GET /users/1.xml
	def show
	
		if signed_in?
			#get the user from the id
			@user = User.find(params[:id])
			#user.name = user's name
			@title = @user.name
		else
			redirect_to root_path
		end
	end
	
	def home
		if signed_in?
		else
			redirect_to root_path
		end
	end
	
	# GET /users/1/edit
	def edit
		if signed_in?
			@user = current_user
		else
			redirect_to root_path
		end
	end
	
	# PUT /users/1
	# PUT /users/1.xml
	def update
		if signed_in?
			@user = current_user
			
			if @user.update_attributes(params[:user])
				flash[:success] = "Profile updated."
				redirect_to home_path
			else
				@title = "Edit user"
				render 'edit'
			end
		else
			redirect_to root_path
		end
	end
	
	#----------------------------------------------------------------
	# GET /users
	# GET /users.xml
	def index
	@users = User.all

	respond_to do |format|
	format.html # index.html.erb
	format.xml  { render :xml => @users }
	end
	end

	

	
	
	

	

	

	# DELETE /users/1
	# DELETE /users/1.xml
	def destroy
	@user = User.find(params[:id])
	@user.destroy

	respond_to do |format|
	format.html { redirect_to(users_url) }
	format.xml  { head :ok }
	end
	end
	
	def mail
		@user = User.first
		UserMailer.welcome_email(@user).deliver
	end
end
