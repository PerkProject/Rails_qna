require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Vote answers', %q{
  In order to vote answers
  As an authenticated user
  I want to be able to vote answer
} do

  given!(:user){create(:user)}
  given!(:question){create(:question)}
  given!(:answer){create(:answer, question: question)}

  context 'Authenticated user' do

    before :each do
      sign_in(user)
      visit question_path(question)
    end

  scenario 'User can vote-up for the answer', js: true do

    within '.answers' do
      click_on '+'
      click_on '+'
      expect(page).to have_content '1'
    end
  end

  scenario 'User can vote down for the answer', js: true do

    within '.answers' do
      click_on '-'
      click_on '-'
      expect(page).to have_content '-1'
    end
  end

  scenario 'User can cancel vote for the answer', js: true do

    within '.answers' do
      click_on '+'
      click_on 'cancel'
      expect(page).to have_content '0'
    end
  end
  end

  context 'Non-authenticated user' do
    before :each do
      visit question_path(question)
    end

    scenario 'User try to vote up an answer', js: true do
      within '.answers' do
        expect(page).to_not have_content('+1')
      end
    end

    scenario 'User try to vote down an answer', js: true do
      within '.answers' do
        expect(page).to_not have_content('-1')
      end
    end
  end
end