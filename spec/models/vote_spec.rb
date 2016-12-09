require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_type, :votable_id]) }
end
