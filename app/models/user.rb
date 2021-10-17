class User < ApplicationRecord
	VALID_EMAIL_REGEX = /\A[\w+_.-]+@[a-z.-]+\.[\w]+\z/i
	has_secure_password

	before_save   :downcase_email
	before_create :create_activation_digest
	attr_accessor :remember_token, :activation_token

	validates :name, 
		presence:true, 
		length:{ maximum:50 }

	validates :email, 
		presence:true, 
		length:{ maximum:255 }, 
		format:{ with:VALID_EMAIL_REGEX },
		uniqueness:{ case_sensitive:false }

	validates :password,
		presence:true,
		length:{ minimum:6 },
		allow_nil:true

	def remember
		@remember_token = self.class.new_token
		update_attribute(:remember_digest, self.class.digest(remember_token))
		remember_digest
	end
	def authenticated?(attr, token)
		digest = send("#{attr}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end
	def forget
		update_attribute(:remember_digest, nil)
	end
	def session_token
		remember_digest || remember
	end
	class << self
		def digest(password)
			cost = ActiveModel::SecurePassword.min_cost ?
				BCrypt::Engine::MIN_COST :
				BCrypt::Engine.cost
			BCrypt::Password.create(password, cost:cost)
		end

		def new_token
			SecureRandom.urlsafe_base64
		end
	end
	private
	def create_activation_digest
		@activation_token  = self.class.new_token
		self.activation_digest = self.class.digest(activation_token)
	end
	def downcase_email
		self.email.downcase!
	end
end
