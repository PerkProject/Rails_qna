json.(@comment, :id, :content, :user_id, :commentable_type, :commentable_id)

json.parent do
  json.type @comment.commentable_type.underscore
  json.id @comment.commentable_id
end