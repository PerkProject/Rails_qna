require 'rails_helper'

RSpec.describe Search, type: :sphinx do
  describe '.find' do
    let!(:question1) { create(:question, title: 'find_question_title', body: 'body') }
    let!(:question2) { create(:question, title: 'title', body: 'find_question_body') }
    let!(:question3) { create(:question, title: 'other', body: 'other') }
    let!(:answer1) { create(:answer, body: 'find_answer_body') }
    let!(:answer2) { create(:answer, body: 'other') }
    let!(:comment1) { create(:comment, content: 'find_comment_body', commentable: answer1) }
    let!(:comment2) { create(:comment, content: 'other') }
    let!(:user1) { create(:user, email: 'findmeuser@mail.com') }
    let!(:user2) { create(:user, email: 'otheruser@mail.com') }

    before do
      index
    end

    context 'when valid arguments' do
      it 'returns requested objects' do
        expect(Search.find('find', 'everywhere'))
          .to match_array [question2, question1, answer1, comment1, user1]
      end
      it 'returns requested questions' do
        expect(Search.find('find', 'questions'))
          .to match_array [question2, question1]
      end
      it 'returns requested answers' do
        expect(Search.find('find', 'answers'))
          .to match_array [answer1]
      end
      it 'returns requested comments' do
        expect(Search.find('find', 'comments'))
          .to match_array [comment1]
      end
      it 'returns requested comments' do
        expect(Search.find('find', 'users'))
          .to match_array [user1]
      end
    end

    context 'when invalid arguments'
    it 'returns empty array' do
      expect(Search.find('find', nil))
        .to match_array []
    end
  end
end
