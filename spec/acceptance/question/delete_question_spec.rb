require_relative '../../../spec/acceptance/acceptance_helper'

feature 'author can delete your question', %q{
  In order only author can delete question
  An author of question
  I want to be able delete question
} do
  given(:user) { create(:user) }

  before(:each) do
    sign_in(user)
    @question = create(:question, user: user)
  end

  scenario 'Author can delete question' do
    visit question_path(@question)

    click_on 'delete question'

    expect(page).to_not have_content @question.title
    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario 'Authenticated user can not delete question by other user' do
    sign_out
    sign_in(create(:user))
    visit question_path(@question)

    expect(page).to_not have_link 'delete question'
  end

  scenario 'Non-authenticated user can not delete question' do
    sign_out

    visit question_path(@question)

    expect(page).to_not have_link 'delete question'
  end

end