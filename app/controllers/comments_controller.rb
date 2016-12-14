class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_comment, only: [:destroy]
  before_action :load_commentable, only: [:new, :create]

  respond_to :json
  respond_to :js, only: [:new]

  def new
    respond_with(@comment = @commentable.comments.new)
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    current_user.comments << @comment
    respond_with(@comment)
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
    end

    head :unprocessable_entity unless @commentable
  end

  def get_comment
    @comment = Comment.find(params[:id])
  end
end