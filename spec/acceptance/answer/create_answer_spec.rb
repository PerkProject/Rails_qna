require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Create answer for question', %q{
  In order to create answer for current question
  As an authenticated user
  I want to be able to write answer for question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create answer for question', js: true do
    sign_in(user)

    visit question_path(question)

    within '.create-answers' do
    fill_in 'Your answer', with: 'Test answer body'
    click_on 'Create answer'
    end
    #within '.answers' do
    expect(page).to have_content 'Test answer body'
    #end
  end

  scenario 'Non-authenticated user ties to create answer' do
    visit question_path(question)

    expect(page).not_to have_field('Body')
    expect(page).not_to have_button('Create answer')
  end

  scenario 'Authenticated user submit invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Create answer'
  #  page.driver.debug
    expect(page).to have_content "Body can't be blank"
    expect(page).not_to have_content 'You answer successfully created.'
  end

end