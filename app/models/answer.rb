# frozen_string_literal: true
class Answer < ApplicationRecord
  include Votable
  include Attachable
  include Commentable
  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :user_id, presence: true

  default_scope { order(best: :desc) }

  after_commit :notify_question_subscribers

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best: false)
      raise ActiveRecord::Rollback if question.answers.where(best: false).exists?(true)
      update(best: true)
    end
  end

  private

  def notify_question_subscribers
    NotifySubscribersJob.perform_later(self, question)
  end
end
