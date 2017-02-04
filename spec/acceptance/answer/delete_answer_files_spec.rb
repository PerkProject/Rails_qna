require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Delete files from answer', "
  In order to illustrate my answer
  As an question's author
  I'd like to be able to delete files
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:other_user) { create(:user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'My answer'
  end

  context 'Authenticated user' do
    scenario 'deletes files for his own answer', js: true do
      click_on 'Add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'
      visit question_path(question)

      within '.answers' do
        click_on 'delete file'
      end

      expect(page).not_to have_content 'spec_helper.rb'
    end

    scenario 'cannot delete other user\'s answer files', js: true do
      click_on 'Add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'
      visit question_path(question)
      sign_out
      sign_in(other_user)
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link('delete file')
      end
    end
  end

  scenario 'Non-authorized user cannot delete files', js: true do
    click_on 'Add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
    sign_out
    visit question_path(question)

    within ("#answer-#{answer.id}") do
      expect(page).not_to have_link('delete file')
    end
  end
end
