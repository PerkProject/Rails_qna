class CommentsChannel < ApplicationCable::Channel
  def follow_question_page_comments(params)
    stream_from "comments-for-question-page-#{params['id']}"
  end
end
