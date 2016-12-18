# frozen_string_literal: true
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  after_action :publish_question, only: [:create]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer ||= @question.answers.build
    @answer.attachments.build
    gon.current_user_id = current_user.id if user_signed_in?
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'You question successfully created.'
      redirect_to @question
    else
      flash[:notice] = 'Question is not created!'
      render :new
    end
  end

  def destroy
    if current_user.check_owner(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully deleted.'
    end
    redirect_to questions_path
  end

  def update
    if current_user.check_owner(@question)
      @question.update(question_params)
    else
      @question.errors.add(:base, message: 'Cannot edit question if not author')
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',
                                 ApplicationController.render(
                                     partial: 'questions/question',
                                     locals: { question: @question }
                                 )
    )
  end
end
