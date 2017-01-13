module Answers
  class ShowSerializer < ActiveModel::Serializer
    attributes :id, :body, :question_id, :created_at, :updated_at

    has_many :comments
    has_many :attachments
  end
end
