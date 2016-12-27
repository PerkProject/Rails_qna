# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_answer, only: [:destroy, :update, :edit, :answer_best]
  before_action :set_question, only: [:create]
  before_action :set_answer_question, only: [:update, :answer_best]
  after_action :publish_answer, only: [:create]

  include Voted

  respond_to :js, :json

  authorize_resource

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: @question.id))
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy) if current_user.check_owner(@answer)
  end

  def edit
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params) if current_user.check_owner(@answer)
    respond_with(@answer)
  end

  def answer_best
    respond_with(@answer.mark_as_best) if current_user.check_owner(@answer)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer_question
    @question = @answer.question
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.required(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    data = {
      type: :answer,
      answer_user_id: current_user.id,
      question_user_id: @question.user_id,
      answer: @answer,
      answer_attachments: @answer.attachments
    }
    ActionCable.server.broadcast("question_answers_#{params[:question_id]}", data)
  end
end
