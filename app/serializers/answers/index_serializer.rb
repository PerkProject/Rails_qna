module Answers
  class IndexSerializer < ActiveModel::Serializer
    attributes :id, :question_id, :body, :created_at, :updated_at
  end
end
