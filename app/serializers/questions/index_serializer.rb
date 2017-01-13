module Questions
  class Questions::IndexSerializer < ActiveModel::Serializer
    attributes :id, :title, :body, :created_at, :updated_at
  end
end
