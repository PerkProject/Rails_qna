require 'rails_helper'
require 'shared_examples/models/attachable_shared'
require 'shared_examples/models/votable_shared'
require 'shared_examples/models/commentable_shared'

RSpec.describe Question, type: :model do
  it_should_behave_like 'votable'
  it_should_behave_like 'attachable'
  it_should_behave_like 'commentable'

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:title).is_at_most(255) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should validate_presence_of(:user_id)}
end
