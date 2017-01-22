class Api::V1::AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at
  has_many :attachments
  has_many :comments

  delegate :question_id, to: :object
end
