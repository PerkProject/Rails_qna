# frozen_string_literal: true
class Question < ApplicationRecord
  include Votable
  include Attachable
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 5, maximum: 255 }
end
