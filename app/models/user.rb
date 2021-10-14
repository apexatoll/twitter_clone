class User < ApplicationRecord
	VALID_EMAIL_REGEX = /\A[\w+_.-]+@[a-z.-]+\.[\w]+\z/i

	before_save { self.email.downcase! }
	has_secure_password

	attr_reader :remember_token

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
	end

	def authenticated?(token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest)
			.is_password?(token)
	end

	def forget
		update_attribute(:remember_digest, nil)
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
end
