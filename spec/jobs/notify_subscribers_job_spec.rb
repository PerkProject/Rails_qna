require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:question) { create :question }
  let(:subscriptions) { create_list(:subscription, 2, question: question) }
  let(:answer) { create :answer, question: question }

  it 'sends emails to subscribers' do
    answer.question.subscriptions.each do |subscription|
      expect(NotificationsMailer).to receive(:new_answer).with(answer, subscription.user.email).and_call_original
    end
    NotifySubscribersJob.perform_now(answer, question)
  end
end
