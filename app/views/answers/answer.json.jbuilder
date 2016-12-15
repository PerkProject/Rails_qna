json.extract! @answer, :id, :question_id, :body, :user_id
json.user @answer.user, :id
json.question @question, :id, :title, :body, :user_id
json.update_url  question_answers_path(@question, @answer)
json.destroy_url question_answers_path(@question, @answer)
json.best_url  answer_best_answer_path(@answer, @answer.id)


json.attachments @answer.attachments do |attach|
  json.id attach.id
  json.file_name attach.file.identifier
  json.file_url attach.file.url
end