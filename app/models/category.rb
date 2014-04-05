class Category < ActiveRecord::Base
  has_many :posts, :dependent => :delete_all

  validates :name,:presence => true
end
