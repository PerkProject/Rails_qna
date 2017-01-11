module Questions
  class Questions::CreateSerializer < ActiveModel::Serializer
    attributes :id, :title, :body, :created_at, :updated_at
  end
end