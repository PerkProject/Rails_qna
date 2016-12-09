# frozen_string_literal: true
module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:voteup, :votedown, :votedel]
    before_action :check_votable_owner, only: [:voteup, :votedown]
    before_action :check_count_vote, only: [:voteup, :votedown]
  end

  def voteup
    @votable.voteup(current_user)
    response_good_json
  end

  def votedown
    @votable.votedown(current_user)
    response_good_json
  end

  def votedel
    if @votable.check_vote current_user
      @votable.votedel(current_user)
      response_good_json
    else
      render json: { id: @votable.id, status: 'error', data: 'Need vote first' }, status: :ok
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def response_good_json
    render json: { id: @votable.id, status: 'success', rating: @votable.rating }, status: :ok
  end

  def check_votable_owner
    if current_user.check_owner(@votable)
      render json: { id: @votable.id, status: 'error', data: 'You can\'t vote because you owner this object' }, status: :forbidden
    end
  end

  def check_count_vote
    if @votable.check_vote(current_user)
      render json: { id: @votable.id, status: 'error', data: 'You can vote only once' }, status: :ok
    end
  end
end
