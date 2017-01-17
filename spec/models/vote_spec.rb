require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to(:votable) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to([:votable_type, :votable_id]) }
end
