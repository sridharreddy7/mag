class Post < ActiveRecord::Base
  belongs_to :category
  has_many :comments, :dependent => :delete_all
  has_many :votes, :dependent => :delete_all

  validates :title,:presence => true
  validates :content,:presence => true

  def self.search (search,search_by)
    search_condition = "%" + search + "%"
    if search_by == '1'
        find(:all, :conditions => ['content LIKE ?', search_condition])
    elsif search_by == '2'
        find(:all,:conditions => ['category_id IN (?)', Category.find(:all,:conditions => ['name LIKE ?',search_condition])])
    elsif search_by == '3'
      find(:all,:conditions => ['user_id IN (?)', User.find(:all,:conditions => ['fname LIKE ?',search_condition])])
    end
  end
end
