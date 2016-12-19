# frozen_string_literal: true
class Answer < ApplicationRecord
  include Votable
  include Attachable
  include Commentable
  belongs_to :question
  belongs_to :user

  validates :body, :user_id, presence: true

  default_scope { order(best: :desc) }

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best: false)
      raise ActiveRecord::Rollback if question.answers.where(best: false).exists?(true)
      update(best: true)
    end
  end
end
