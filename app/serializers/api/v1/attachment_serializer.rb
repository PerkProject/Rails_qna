class Api::V1::AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :created_at

  def url
    object.file.url
  end
end
