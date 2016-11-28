require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Edit answer', %q{
  In order to control editing answer
  As an author of answer
  I want to be able to edit answer
} do

  given(:user)       { create(:user) }
  given!(:question)  { create :question, user_id: user.id }
  given(:other_user) { create :user }
  given!(:answer)    { create :answer, question_id: question.id, user_id: user.id }

  scenario "Non-authenticated user try to edit answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Author edit his own answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit'

    within '.answers' do
      fill_in 'Answer', with: 'EditAnswerText'
      click_on 'Save'

      expect(page).to have_content 'EditAnswerText'
      expect(page).to have_no_content answer.body
      end
  end

  scenario 'Authenticated user make invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit'

    within '.edit-answer-form' do
     fill_in 'Answer' , with: ''
     click_on 'Save'
    end

    expect(page).to have_content "Body can't be blank"

  end

  scenario 'Authenticated user cannot edit other users answer' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

end