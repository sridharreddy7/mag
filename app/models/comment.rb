class Comment < ActiveRecord::Base
  belongs_to :post
  has_many :votes, :dependent => :delete_all
end
