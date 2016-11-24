require_relative '../../../spec/acceptance/acceptance_helper'

feature 'view questions list', %q{
In order to be a list of questions
As any user
I want to be able see list question
} do

  given(:question) {create(:question)}

  scenario 'Any user can see questions list' do
    list = create_list(:question, 3)
    visit questions_path

    list.each do |f|
      expect(page).to have_link(f.title)
      expect(page).to have_content f.title
    end

    have_css("li", :count => 3)

  end

end