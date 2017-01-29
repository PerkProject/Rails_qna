class SubscriptionsController < ApplicationController
  respond_to :js

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = Subscription.create(question: @question, user: current_user)
    respond_with(@subscription)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    respond_with(@subscription.destroy)
  end
end
