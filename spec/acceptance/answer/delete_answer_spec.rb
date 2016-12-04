require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Delete answer', %q{
In order only author can delete answer
As author of answer
I want to be able to delete my answer
} do

  given!(:user) { create(:user) }
  #let! sign_in(user)
  given!(:question) { create((:question), user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }


  scenario 'Author can delete your answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete answer'
    page.reset!
    expect(page).to_not have_content(answer.body)
  end

  scenario 'Authenticated user can not delete answer by other user', js: true do
    sign_in(user)
    sign_out
    sign_in(create(:user))

    visit question_path(question)

    within '.answer#' + "answer-#{answer.id}" do
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Non-authenticated user can not delete answer', js: true do
    sign_in(user)
    sign_out

    visit question_path(question)

    within '.answer#' + "answer-#{answer.id}" do
      expect(page).to_not have_link 'Delete answer'
    end
  end
end