require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Vote answers', '
  In order to vote answers
  As an authenticated user
  I want to be able to vote answer
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can vote-up for the answer', js: true do
      within '.answers' do
        click_on '+'
        click_on '+'
      end

      within '.answer-rating' do
        expect(page).to have_content '1'
      end
    end

    scenario 'User can vote down for the answer', js: true do
      within '.answers' do
        click_on '-'
        click_on '-'
      end

      within '.answer-rating' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'User can cancel vote for the answer', js: true do
      within '.answers' do
        click_on '+'
        click_on 'cancel'
      end

      within '.answer-rating' do
        expect(page).to have_content '0'
      end
    end
  end

  context 'Non-authenticated user' do
    before do
      visit question_path(question)
    end

    scenario 'User try to vote up an answer', js: true do
      within '.answer-rating' do
        expect(page).not_to have_content('+1')
      end
    end

    scenario 'User try to vote down an answer', js: true do
      within '.answer-rating' do
        expect(page).not_to have_content('-1')
      end
    end
  end
end
