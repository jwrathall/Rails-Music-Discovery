class User < ActiveRecord::Base

  require 'bcrypt'
  require 'securerandom'

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  attr_accessible :username
  attr_protected :salt, :hash_password
  attr_accessor :password

  before_save  :create_password
  after_save :clear_fields

  validates :username,:presence => true,
            :format => { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
            :uniqueness => true

  validates :password, :presence => true,
            :length => {:maximum => 25}

  def create_password
    if !password.blank?
      self.salt = User.make_salt(username)
      self.hash_password = User.hash_password(password, salt)
    end
  end
  def self.make_salt(username='')
     random = SecureRandom.hex()
     "#{random}#{username}#{Time.now}"
  end
  def self.hash_password(password='', salt='')
    Digest::SHA2.hexdigest("#{salt}#{password}")
  end

  def clear_fields
    self.password = nil
    self.username = nil
  end
end
