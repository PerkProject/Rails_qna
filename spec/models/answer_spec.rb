require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many :attachments }
  it { should have_db_index :question_id }
  it { should validate_presence_of :body }
  it { should validate_presence_of(:user_id)}
  it { should accept_nested_attributes_for :attachments }

  let(:user){ create(:user) }
  let(:question) {create(:question, user: user)}
  let(:answer) {create(:answer, question: question, user: user)}
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
      expect(answer).to_not be_best
      expect(answer2).to be_best
    end
  end
end
