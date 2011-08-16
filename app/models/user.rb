require 'digest/sha2'

class User < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  
  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader   :password
  
  validate      :password_must_be_present
  
  after_destroy :ensure_an_admin_remains
  
  #creating a hashed password
  
  #Combine salt value with plain text password and produce a single string.
  #Returns 40 character string hex digits
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end
  
  
  #rather than using standard accessors, we implement our own public methods and have the
  #writer also create a new salt and set the hashed password
  
  def password=(password)
    @password = password
    
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  
  #Public method that returns a user object if the caller supplies the correct name and password
  def User.authenticate(name, password)
    if user = find_by_name(name)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end
  
  
  def ensure_an_admin_remains
    if User.count.zero?
      raise "Can't delete last user"
    end
  end
  
  
  
  
  private
  
    def password_must_be_present
      errors.add(:password, "Missing password") unless hashed_password.present?
    end
    
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
    
   
end
