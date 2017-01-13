require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Add comment for answer', '
  In order to make comment for answer
  As an authenticated user
  I want to be able to create comments
' do

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment with valid data', js: true do
      within ("#answer-#{answer.id}") do
        click_on 'add a comment'
        fill_in 'comment_content', with: 'test comment'

        click_on 'Save comment'
      end

      within '.answers' do
        expect(page).to have_content('test comment')
      end
    end

    scenario 'creates comment with invalid data', js: true do
      within ("#answer-#{answer.id}") do
        click_on 'add a comment'

        fill_in 'comment_content', with: 'poo'

        click_on 'Save comment'
      end

      within '.answers' do
        expect(page).not_to have_content('poo')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create comment', js: true do
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_content('Save comment')
      end
    end
  end

  context 'All users get new questions in real-time', js: true do
    before do
      user = create(:user)

      Capybara.using_session('user') do
        sign_in user
        visit question_path(answer.question)
      end

      Capybara.using_session('guest') do
        visit question_path(answer.question)
      end

      Capybara.using_session('user') do
        within ("#answer-#{answer.id}") do
          click_on('add a comment')
          fill_in 'comment_content', with: 'Test answer comment'
          click_on 'Save comment'

          expect(page).to have_css('span', text: 'Test answer comment')
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_css('span', text: 'Test answer comment')
      end

      scenario 'unauthenticated user cannot see comment button', js: true do
        visit question_path(answer.question)

        within('.answer-buttons') { expect(page).not_to have_content('add a comment') }
      end

      scenario 'authenticated user creates the invalid comment', js: true do
        sign_in user
        visit question_path(answer.question)
        within ("#answer-#{answer.id}") do
          click_on('add a comment')
          fill_in 'comment_content', with: 'poo'
          click_on 'Save comment'
        end

        expect(page).to have_content('Body is too short (minimum is 3 characters)')
      end
    end
  end
end
