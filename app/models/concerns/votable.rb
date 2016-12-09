# frozen_string_literal: true
module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voteup(user)
    votes.create(user: user, value: 1)
  end

  def votedown(user)
    votes.create(user: user, value: -1)
  end

  def votedel(user)
    votes.where(user: user).destroy_all
  end

  def rating
    votes.sum(:value)
  end

  def check_vote(user)
    Vote.where(user: user, votable: self).exists?
  end
end
