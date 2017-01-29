require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :question }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :question_id }
end
