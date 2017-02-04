require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Edit answer', '
  In order to control editing answer
  As an author of answer
  I want to be able to edit answer
' do

  given(:user)       { create(:user) }
  given!(:question)  { create :question, user_id: user.id }
  given(:other_user) { create :user }
  given!(:answer)    { create :answer, question_id: question.id, user_id: user.id }

  scenario "Non-authenticated user try to edit answer" do
    visit question_path(question)

    expect(page).not_to have_link 'Edit answer'
  end

  scenario 'Author edit his own answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'edit answer'

    fill_in 'Edit your answer:', with: 'EditAnswerText', match: :first
    click_on 'Save'
    click_on 'Cancel'

    within '.answers' do
      expect(page).to have_content 'EditAnswerText'
      expect(page).to have_no_content answer.body
    end
  end

  scenario 'Authenticated user make invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'edit answer'

    within ("#answer-#{answer.id}") do
      fill_in 'Edit your answer:', with: ''
      click_on 'Save'
    end

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Authenticated user cannot edit other users answer' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).not_to have_link 'edit answer'
  end
end
