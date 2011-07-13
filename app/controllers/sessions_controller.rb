class SessionsController < ApplicationController
	def new
		if not signed_in?
		
		else
			redirect_to home_path
		end
	end
		
	#create will handle the login
	#post to '/sessions'
	def create
		if not signed_in?
			#check the user authentication using email and password
			user = User.authenticate(params[:session][:name],
									params[:session][:password])
			
			# if user is not authenticated
			if user.nil?
				flash.now[:error] = "Invalid email/password combination."
			
				# sign in
				@title = "Sign in"
				render 'new'
			else
				#if a valid name and password then signin user // defined in session_helper
				sign_in user
        session[:user_id] = current_user.id
        session[:user_type] = current_user.user_type
				#redirect_back_or user
				redirect_to home_path
			end
		else
			redirect_to home_path
		end
		
	end
	
	def destroy
		sign_out
		redirect_to root_path
	end
	
end
