# frozen_string_literal: true
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :set_show_settings, only: [:show]
  after_action :publish_question, only: [:create]

  include Voted

  respond_to :html, :js, :json

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
    @question = current_user.questions.build
    respond_with(@question)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy) if current_user.check_owner(@question)
  end

  def update
    respond_with(@question) if current_user.check_owner(@question)
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
                                 ))
  end

  def set_show_settings
    @answers = @question.answers
    @answer ||= @question.answers.build
    @answer.attachments.build
    gon.current_user_id = current_user.id if user_signed_in?
    gon.push(question_id: @question.id)
  end
end
