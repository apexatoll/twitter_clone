class User < ApplicationRecord
  before_save { self.email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+_.-]+@[a-z.-]+\.[\w]+\z/i

  validates :name, 
    presence:true, 
    length:{ maximum:50 }
  validates :email, 
    presence:true, 
    length:{ maximum:255 }, 
    format:{ with:VALID_EMAIL_REGEX },
    uniqueness:{ case_sensitive:false }
end
