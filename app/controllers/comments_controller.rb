class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_comment, only: [:destroy]
  before_action :load_commentable, except: [:destroy]
  after_action :publish_comment, only: [:create]

  respond_to :js

  def new
    @comment = @commentable.comments.build
    respond_with @comment
  end

  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
    respond_with @comment
  end

  def destroy
    respond_with @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
      @question_id = @commentable.id
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
      @question_id = @commentable.question.id
    end

    head :unprocessable_entity unless @commentable
  end

  def get_comment
    @comment = Comment.find(params[:id])
  end

  def publish_comment
    data = {
      type: :comment,
      comment: @comment
    }
    ActionCable.server.broadcast("question_comments_#{@question_id}", data)
  end
end
