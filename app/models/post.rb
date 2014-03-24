class Post < ActiveRecord::Base
	has_many :comments
  	has_and_belongs_to_many :categories
      validates_presence_of :title, :body
end
