class User < ActiveRecord::Base
  has_many :votes, :dependent => :delete_all
  attr_accessible :email, :fname, :lname, :password, :usertype
  validates_uniqueness_of :email
  validates_length_of :fname, :within => 4..20
  validates_length_of :password, :within => 4..20
  validates_length_of :email, :maximum => 50
  validates_format_of :password, :with => /^[A-Z0-9_]*$/i, :message => "must contain only letters, numbers, and underscores"
  validates_format_of :email, :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i, :message => "must be a valid email address"

  def self.sign_in(email, password)
    user = User.find_by_email(email)
    if user
      if password == user.password
        user
      else
        nil
      end
    end
  end
end
