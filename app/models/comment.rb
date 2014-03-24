class Comment < ActiveRecord::Base
  belongs_to :post
	
 
      validates_presence_of :body, :post
      validates_associated  :post

end
