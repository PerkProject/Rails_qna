json.(comment, :id, :content)

json.parent do
  json.type comment.commentable_type.underscore
  json.id comment.commentable_id
end