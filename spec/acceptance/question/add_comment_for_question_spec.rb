require_relative '../../../spec/acceptance/acceptance_helper'

feature 'add comment for question', '
  In order to add new information for question
  As an authenticated user
  I want to be able to ask anything in comments about question
' do

  let(:question) { create(:question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can see "add comment" link', js: true do
      within '#question-body' do
        # page.driver.debug
        expect(page).to have_link 'add a comment'
      end
    end

    scenario 'add comment with valid data', js: true do
      within ('#question-body') { click_on 'add a comment' }

      within '.question-comments' do
        fill_in 'Your comment', with: 'test comment'

        click_on 'Save comment'

        expect(page).to have_content('test comment')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'try create comment', js: true do
      visit question_path(question)

      expect(page).not_to have_css('.question .new-comment')
    end
  end

  context 'All users get new questions in real-time' do
    before do
      author = create(:user)
      guest = create(:user)
      question = create(:question, user: author)

      Capybara.using_session('authenticated_author_creator') do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session('authenticated_author_reader') do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session('authenticated_guest') do
        sign_in(guest)
        visit question_path(question)
      end

      Capybara.using_session('non_authenticated_guest') do
        visit question_path(question)
      end

      Capybara.using_session('authenticated_author_creator') do
        within ('#question-body') { click_on 'add a comment' }
        within '.question-comments' do
          fill_in 'Your comment', with: 'test comment'

          click_on 'Save comment'
        end
      end
    end

    scenario 'authenticated guest', js: true do
      Capybara.using_session('authenticated_guest') do
        within '.question-comments' do
          expect(page).to have_content 'test comment'
        end
      end
    end

    scenario 'non-authenticated guest', js: true do
      Capybara.using_session('non_authenticated_guest') do
        within '.question-comments' do
          expect(page).to have_content ''
        end
      end
    end

    scenario 'authenticated author as reader', js: true do
      Capybara.using_session('authenticated_author_reader') do
        within '.question-comments' do
          expect(page).to have_content 'test comment'
        end
      end
    end
  end
end
