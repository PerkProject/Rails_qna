json.extract! @question, :id, :title, :body, :user_id
json.edit_url edit_question_path(@question)
json.destroy_url question_path(@question)