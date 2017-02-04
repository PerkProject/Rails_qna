class Api::V1::QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :attachments
  has_many :comments
end
