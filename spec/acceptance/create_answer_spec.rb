require 'rails_helper'

feature 'Create answer for question', %q{
  In order to create answer for current question
  As an authenticated user
  I want to be able to write answer for question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create answer for question' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'Test answer body'

    click_on 'Create answer'

    expect(page).to have_content 'Test answer body'
  end

  scenario 'Non-authenticated user ties to create answer' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end