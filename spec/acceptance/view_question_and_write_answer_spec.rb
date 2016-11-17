require 'rails_helper'

feature 'view question and write answer', %q{
In order to be a question and existing answer to it
As any user
I want to be able see view question with answer
} do

  given(:question) {create(:question)}

  scenario 'Any user can view question and answer for him' do
    a , q = create_list(:answer,2, question: question)

    visit question_path(question)
    fill_in 'Body', with: 'TestText'

    expect(page).to have_content question.title
    expect(page).to have_content a.body
    expect(page).to have_content q.body

    expect(page).to have_field("Body", :with =>'TestText')

  end

end