class User < ActiveRecord::Base
	attr_accessor :password
  has_many :cart_items
  has_many :invoices
	
	# these fields are directly accessible
		#attr_accessible :name, :email
	#for signup we need the password and password_confirmation
	attr_accessible :name, :password, :password_confirmation
	
	#validate the name
	#presence - blank fild
	#length - limit the max length
	validates :name, 	:presence => true,
						:length => { :maximum => 50 },
						:uniqueness => {:case_sensitive => false}
	
	#validate password
	#presence - blank fild
	#confirmation - match with confirm_password
	#length - :within ->set the min and max limit
	validates :password, 	:presence => true,
							:confirmation => true, #this l create a virtual field in the users table "password_confirmation"
							:length => { :within => 6..40 }
							
	#before_save => calls a function before saving a active record.
	#Here it is calling encrypt_password(private)
	before_save :encrypt_password
	
	#authenticate method
	#param : name,submitted_password
	def self.authenticate(name, submitted_password)
		#get the user be the email
		user = find_by_name(name)
		
		#if not found return nil
		return nil if user.nil?
		
		#call the has_password
		#if the encrypted password matches the submitted password returns true
		return user if user.has_password?(submitted_password)
	end
	
	# Return true if the user's password matches the submitted password.
	#meant for login(authentication)
	def has_password?(submitted_password)
		# Compare encrypted_password with the encrypted version of
		# submitted_password.
		self.encrypted_password == encrypt(submitted_password)
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	
	#--------------------------------------------------------------------------------------------------------------------------------------------------
	#---------------------------------------------PRIVATE SECTION ---------------------------------------------------------------------------------------
	#---------------------------------------------------------------------------------------------------------------------------------------------------
	private
		
		def encrypt_password
			self.salt = make_salt if new_record?
			# self is the object of that class(user)
			# encrypted_password = encrypt(password) => a local variable
			# self.encrypted_password => the class variable
			# encrypt functyion(private) =>param password == self.password
			self.encrypted_password = encrypt(password)
		end
		
		#encrypt function
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
	
end
