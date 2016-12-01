# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable

  validates :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order(best: :desc) }

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best: false)
      raise ActiveRecord::Rollback if question.answers.where(best: false).exists?(true) # .first.nil?
      update(best: true)
    end
  end
end
