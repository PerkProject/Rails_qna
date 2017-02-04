class NotifySubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(answer, question)
    question.subscriptions.each do |subscription|
      NotificationsMailer.new_answer(answer, subscription.user.email).deliver_later
    end
  end
end
