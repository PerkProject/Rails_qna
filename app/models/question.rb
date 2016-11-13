# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { minimum: 5, maximum: 255 }
end
