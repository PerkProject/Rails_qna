module Answers
  class CreateSerializer < ActiveModel::Serializer
    attributes :id, :body, :created_at, :updated_at
  end
end
