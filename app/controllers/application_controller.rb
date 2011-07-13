class ApplicationController < ActionController::Base
	protect_from_forgery
	include SessionsHelper
	before_filter :set_cache_buster, :set_session_check
	
	def set_cache_buster
		response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
		response.headers["Pragma"] = "no-cache"
		response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    #cookies.delete(:_inventory_management_session)
	end
  
  def set_session_check
    if session[:id]
      
    else
      if not current_user.nil?
        session[:id] = current_user.id
        session[:user_type] = current_user.user_type
      end
    end
  end
   protected
  RECAPTCHA_PRIVATE_KEY = '6LfPFMYSAAAAAM5FdbrRCro40Qnbvn9UmzpwvH0w'

  #try and verify the captcha response. Then give out a message to flash
  def verify_recaptcha(remote_ip, params)

     require 'net/http'
	 responce = Net::HTTP.post_form(URI.parse('http://www.google.com/recaptcha/api/verify'),
                                   {'privatekey'=>RECAPTCHA_PRIVATE_KEY, 'remoteip'=>remote_ip, 'challenge'=>params[:recaptcha_challenge_field], 'response'=> params[:recaptcha_response_field]})
      result = {:status => responce.body.split("\n")[0], :error_code => responce.body.split("\n")[1]}

      if result[:error_code] == "incorrect-captcha-sol"
        flash[:alert] = "The CAPTCHA solution was incorrect. Please re-try"
      elsif not result[:error_code] == "success"
        flash[:alert] = "There has been a unexpected error with the application. Please contact the administrator. error code: #{result[:error_code]}"
      end

      result
	
  end 
  
end
