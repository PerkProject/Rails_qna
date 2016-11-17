require 'rails_helper'

feature 'view questions list', %q{
In order to be a list of questions
As any user
I want to be able see list question
} do

  given(:question) {create(:question)}

  scenario 'Any user can see questions list' do
    list = create_list(:question, 3)
    visit questions_url

    expect(page).to have_link("MyString")
    have_css("li", :count => 2)
    expect(page).to have_content question.title

  end

end