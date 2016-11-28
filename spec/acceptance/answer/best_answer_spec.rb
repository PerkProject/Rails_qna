require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Select Best Answer', %q{
  In order to mark best answer
  As author of the question
  I want to be able to pick the best answer
}do
  describe 'Author of the question' do

    given(:user)        { create(:user) }
   # given(:other_user)  { create(:user) }
    given(:question)    { create(:question, user_id: user.id) }
    given!(:answer)     { create_list(:answer, 5 , user: user, question: question) }

    scenario 'can see accept answer button for answer' do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_css('.best-link', count: 5)
    end

    scenario "when author of question click 'make best',this answer mark as best", js: true do
      sign_in(user)
      visit question_path(question)
      click_link('make best', match: :first)

      expect(page).to have_css('.best-link', count: 4)
      expect(page).to have_css('.better-link', count: 1)
    end

    describe "when user is non-author of question" do
      given!(:question)    { create(:question, user_id: user.id) }
      given!(:answer)     { create_list(:answer, 2, user: user, question: question) }

      scenario 'can not see best answer link' do
        visit question_path(question)
        expect(page).to_not have_css('.best-link')
      end

    end
  end
end
