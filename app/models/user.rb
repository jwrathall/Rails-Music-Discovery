class User < ActiveRecord::Base

  require 'bcrypt'
  require 'securerandom'

  attr_accessible :username, :password
  attr_protected :salt, :hash_password

  before_save  :create_password


  def create_password
    if !password.blank?
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

  def self.exists(username='')
    user_count = User.where(:username => username).count()
    if user_count > 1
      return true
    else
      return false
    end

  end
end
