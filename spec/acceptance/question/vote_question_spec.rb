require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Vote question', %q{
  In order to vote question
  As an authenticated user
  I want to be able to vote question
} do

  given!(:question){create(:question)}

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit question_path(question)
    end

  scenario 'User can vote-up for the question', js: true do

    click_on '+'
    click_on '+'

    within '.rating' do
      expect(page).to have_content '1'
    end
  end

  scenario 'User can vote-down for the question', js: true do

    click_on '-'
    click_on '-'

    within '.rating' do
      expect(page).to have_content '-1'
    end
  end

  scenario 'User can choose cancel vote for the question', js: true do

    click_on '+'
    click_on 'cancel'
    within '.rating' do
      expect(page).to have_content '0'
    end
  end
  end

  context 'Non-authenticated user' do
    before :each do
      visit question_path(question)
    end

    scenario 'User try to vote up an question', js: true do

        expect(page).to_not have_content('+1')
    end

    scenario 'User try to vote down an question', js: true do

        expect(page).to_not have_content('-1')

    end
    end
end
