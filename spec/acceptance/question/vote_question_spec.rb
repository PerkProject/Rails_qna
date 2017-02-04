require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Vote question', '
  In order to vote question
  As an authenticated user
  I want to be able to vote question
' do

  given!(:question) { create(:question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote-up for the question', js: true do
      click_on '+'
      click_on '+'

      within '.question-rating' do
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote-down for the question', js: true do
      click_on '-'
      click_on '-'

      within '.question-rating' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'can choose cancel vote for the question', js: true do
      click_on '+'
      click_on 'cancel'
      within '.question-rating' do
        expect(page).to have_content '0'
      end
    end
  end

  context 'Non-authenticated user' do
    before do
      visit question_path(question)
    end

    scenario 'User try to vote up an question', js: true do
      expect(page).not_to have_content('+1')
    end

    scenario 'User try to vote down an question', js: true do
      expect(page).not_to have_content('-1')
    end
  end
end
