# frozen_string_literal: true
class Answer < ApplicationRecord
  include Votable
  include Attachable
  include Commentable
  belongs_to :question
  belongs_to :user

  validates :body, :user_id, presence: true

  default_scope { order(best: :desc) }

  after_create :send_notification

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best: false)
      raise ActiveRecord::Rollback if question.answers.where(best: false).exists?(true)
      update(best: true)
    end
  end

  private

  def send_notification
    NotificationsMailer.new_answer(self, question.user.email).deliver_later
  end
end
