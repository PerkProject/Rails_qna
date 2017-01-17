class Api::V1::CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :user_email, :commentable_type, :commentable_id, :updated_at

  def user_email
    object.user.email
  end
end