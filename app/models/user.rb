class User < ActiveRecord::Base

  require 'bcrypt'

  attr_accessible :username, :password
  attr_protected :salt, :hash
  attr_accessor :input_password


end
