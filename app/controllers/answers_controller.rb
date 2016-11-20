# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'You answer successfully created.'
      redirect_to @question
    else
      flash[:notice] = 'Answer is not created!'
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.check_owner(@answer)
      flash[:notice] = 'Your answer successfully deleted.'
      @answer.destroy
    end
    redirect_to @answer.question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.required(:answer).permit(:body)
  end
end
