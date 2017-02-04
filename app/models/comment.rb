class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true, length: { minimum: 5 }

  def root_id
    commentable_type == 'Question' ? commentable_id : Answer.find(commentable_id).question_id
  end
end
