class User < ActiveRecord::Base

  require 'bcrypt'
  require 'securerandom'

  attr_accessible :username, :password
  attr_protected :salt, :hash_password

  before_save :exists, :create_password


  def create_password
    if !self.exists
      self.salt = User.make_salt(username)
      self.hash_password = User.hash_password(password, salt)
      clear_password
    end
  end
  def self.make_salt(username='')
     random = SecureRandom.hex()
     "#{random}#{username}#{Time.now}"
  end
  def self.hash_password(password='', salt='')
    Digest::SHA2.hexdigest("#{salt}#{password}")
  end

  def clear_password
    self.password = nil
  end

  def exists
    user_count = User.where(:username => self.username).count()
    if user_count > 1
      return true
    else
      return false
    end

  end
end
