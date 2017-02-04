require 'rails_helper'
require 'shared_examples/models/attachable_shared'
require 'shared_examples/models/votable_shared'
require 'shared_examples/models/commentable_shared'

RSpec.describe Question, type: :model do
  it_should_behave_like 'votable'
  it_should_behave_like 'attachable'
  it_should_behave_like 'commentable'

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:title).is_at_most(255) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }

  describe '#subscribe_author' do
    let(:user) { create :user }
    let(:question) { build(:question, user: user) }

    it 'subscribes question owner on question' do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end

    it 'performs after question has been created' do
      expect(question).to receive(:subscribe_author)
      question.save
    end
  end
end
