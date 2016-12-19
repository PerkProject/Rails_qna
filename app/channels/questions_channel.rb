class QuestionsChannel < ApplicationCable::Channel
  def follow_questions_stream
    stop_all_streams
    stream_from 'questions'
  end

  def unfollow_questions_stream
    stop_all_streams
  end
end
