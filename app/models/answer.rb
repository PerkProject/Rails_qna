# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :user_id, presence: true

  default_scope { order(best: :desc) }

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best:false)
      raise ActiveRecord::Rollback unless question.answers.where(best: true).first.nil?
      update(best:true)
    end
  end
end
