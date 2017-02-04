# frozen_string_literal: true
class Question < ApplicationRecord
  include Votable
  include Attachable
  include Commentable

  scope :to_daily_digest, -> { where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight) }

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 5, maximum: 255 }

  after_create :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user: user)
  end
end
