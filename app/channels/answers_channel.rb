class AnswersChannel < ApplicationCable::Channel
  def subscribe_question_stream(data)
    stop_all_streams
    stream_from "question_answers_#{data['id']}"
    stream_from "question_comments_#{data['id']}"
  end

  def unsubscribe_question_stream
    stop_all_streams
  end
end
