require_relative '../../../spec/acceptance/acceptance_helper'


feature 'add comment for question', %q{
  In order to add new information for question
  As an authenticated user
  I want to be able to ask anything in comments about question
} do

  let(:question) { create(:question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment with valid data', js: true do
      within '.question' do

        fill_in 'comment_body', with: 'Test comment'

        click_on 'save comment'
      end

      within '.comments-for-question-list' do
        expect(page).to have_content('Test comment')
      end
    end

    scenario 'creates comment with invalid data', js: true do
      within '.question' do

        fill_in 'comment_body', with: ' '

        click_on 'save comment'
      end

      within '.comments-for-question-list' do
        expect(page).to_not have_content(' ')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'try create comment', js: true do
      visit question_path(question)

      expect(page).to_not have_css('.question .new-comment')
    end
  end

  context 'All users get new questions in real-time' do
    before :each do
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
        within '.question' do

          fill_in 'comment_body', with: 'test comment'

          click_on 'save comment'
        end
      end
    end

    scenario 'authenticated guest', js: true do
      Capybara.using_session('authenticated_guest') do
        within '.comments-for-question-list' do
          expect(page).to have_content 'test comment'
        end
      end
    end

    scenario 'non-authenticated guest', js: true do
      Capybara.using_session('non_authenticated_guest') do
        within '.comments-for-question-list' do
          expect(page).to have_content 'test comment'
        end
      end
    end

    scenario 'authenticated author as reader', js: true do
      Capybara.using_session('authenticated_author_reader') do
        within '.comments-for-question-list' do
          expect(page).to have_content 'test comment'
        end
      end
    end
  end
end