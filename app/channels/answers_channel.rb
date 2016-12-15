class AnswersChannel < ApplicationCable::Channel
  def follow_answer(params)
    stream_from "answers-question-#{params['id']}"
  end
end