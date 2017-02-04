require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }

  it 'sends daily digest to each user' do
    users.each { |_user| expect(DailyDigestMailer).to receive(:daily_digest).and_call_original }
    DailyDigestJob.perform_now
  end
end
