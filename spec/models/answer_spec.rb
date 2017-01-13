require 'rails_helper'
require 'shared_examples/models/attachable_shared'
require 'shared_examples/models/votable_shared'
require 'shared_examples/models/commentable_shared'

RSpec.describe Answer, type: :model do
  it_should_behave_like 'votable'
  it_should_behave_like 'attachable'
  it_should_behave_like 'commentable'

  it { is_expected.to belong_to :question }
  it { is_expected.to have_db_index :question_id }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of(:user_id) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  context 'Validate changing answer best status' do
    it 'change the answer status' do
      answer.mark_as_best
      answer.reload
      expect(answer).to be_best
    end
    it 'Change best status from answer and other answer not change' do
      answer2 = create(:answer, question: question, user: user)
      answer.mark_as_best
      answer2.mark_as_best
      answer.reload
      answer2.reload
      expect(answer).not_to be_best
      expect(answer2).to be_best
    end
  end
end
