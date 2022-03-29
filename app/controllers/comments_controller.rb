class CommentsController < ApplicationController
  before_action :set_post, only: [:edit, :create]

  def edit
    @comment = @post.comments.find(params[:id])
    render 'comments/edit'
  end

  def update
    comment = Comment.find(params[:id])
    post = comment.post
    comment.content = params[:comment][:content]

    respond_to do |format|
      if comment.save
        format.html { redirect_to post, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end


  def create
    @post.comments.create! params.required(:comment).permit(:content,:player_id)
    redirect_to @post
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end
end
