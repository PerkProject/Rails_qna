# frozen_string_literal: true
class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.required(:answer).permit(:body)
  end
end
