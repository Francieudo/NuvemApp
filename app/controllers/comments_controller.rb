class CommentsController < ApplicationController
  

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    unless @comment.save
    	flash[:alert] = 'Fail to receive the comment'
    end

   redirect_to @post
  end

private

    def comment_params
      params.require(:comment).permit(:author, :email, :url, :body, :post_id)
    end

  
end
