require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Add comment for answer', %q{
  In order to make comment for answer
  As an authenticated user
  I want to be able to create comments
} do

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment with valid data', js: true do
      within ".answers" do

        fill_in 'comment_content', with: 'test comment'

        click_on 'save comment'
      end

      within '.comments-for-answer-list' do
        expect(page).to have_content('test comment')
      end
    end

    scenario 'creates comment with invalid data', js: true do
      within ".answers" do

        fill_in 'comment_content', with: ' '

        click_on 'save comment'
      end

      within '.comments-for-answer-list' do
        expect(page).to_not have_content(' ')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create comment', js: true do
      visit question_path(question)

      within ".answers" do
        expect(page).to_not have_content('Add comment')
      end
    end
  end

  context 'All users get new questions in real-time' do
    before :each do
      author = create(:user)
      guest = create(:user)

      Capybara.using_session('authenticated_user_author_reader') do
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

      Capybara.using_session('authenticated_user_author_creator') do
        within ".answers" do

          fill_in 'comment_content', with: 'test comment'

          click_on 'save comment'
        end
      end
    end

    scenario 'authenticated guest', js: true do
      Capybara.using_session('authenticated_guest') do
        within ".answers .comments-for-answer-list" do
          expect(page).to have_content 'test comment'
        end
      end
    end

    scenario 'non-authenticated guest', js: true do
      Capybara.using_session('non_authenticated_guest') do
        within ".answers .comments-for-answer-list" do
          expect(page).to have_content 'test comment'
        end
      end
    end

    scenario 'authenticated author as reader', js: true do
      Capybara.using_session('authenticated_user_author_reader') do
        within ".answers .comments-for-answer-list" do
          expect(page).to have_content 'test comment'
        end
      end
    end
  end
end