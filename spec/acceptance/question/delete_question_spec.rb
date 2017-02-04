require_relative '../../../spec/acceptance/acceptance_helper'

feature 'author can delete your question', '
  In order only author can delete question
  An author of question
  I want to be able delete question
' do
  given(:user) { create(:user) }

  before do
    sign_in(user)
    @question = create(:question, user: user)
  end

  scenario 'Author can delete question' do
    visit question_path(@question)

    click_on 'delete question'

    expect(page).not_to have_content @question.title
    expect(page).to have_content 'Question was successfully destroyed.'
  end

  scenario 'Authenticated user can not delete question by other user' do
    sign_out
    sign_in(create(:user))
    visit question_path(@question)

    expect(page).not_to have_link 'delete question'
  end

  scenario 'Non-authenticated user can not delete question' do
    sign_out

    visit question_path(@question)

    expect(page).not_to have_link 'delete question'
  end
end
