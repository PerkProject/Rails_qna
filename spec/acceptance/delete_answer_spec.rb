require 'rails_helper'

feature 'Delete answer', %q{
In order only author can delete answer
As author of answer
I want to be able to delete my answer
} do

  given(:user) { create(:user) }

  before(:each) do
    sign_in(user)
    @question = create((:question), user: user)
    @answer = create(:answer, question: @question, user: user)
  end

  scenario 'Author can delete your answer' do
    visit question_path(@question)
    
    click_on 'Delete answer'

    expect(page).to_not have_content(@answer.body)
  end

  scenario 'Authenticated user can not delete answer by other user' do
    sign_out
    sign_in(create(:user))

    visit question_path(@question)

    expect(page).to have_content(@answer.body)
  end

  scenario 'Non-authenticated user can not delete answer' do
    sign_out

    visit question_path(@question)

    expect(page).to have_content(@answer.body)
  end
end