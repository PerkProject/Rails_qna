# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 5, maximum: 255 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
