# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_answer, only: [:destroy, :update, :edit, :answer_best]
  after_action :publish_answer, only: [:create]

  include Voted

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    flash[:notice] = if @answer.save
                       'You answer successfully created.'
                     else
                       'Answer is not created!'
                     end
  end

  def destroy
    if current_user.check_owner(@answer)
      flash[:notice] = 'Your answer successfully deleted.'
      @answer.destroy
    end
  end

  def edit; end

  def update
    @answer.update(answer_params) if current_user.check_owner(@answer)
    @question = @answer.question
  end

  def answer_best
    @question = @answer.question
    @answer.mark_as_best if current_user.check_owner(@answer)
  end

  private

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
