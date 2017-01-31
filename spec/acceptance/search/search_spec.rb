require 'rails_helper'

feature 'searching',
        'it order to search any object
         As an any user
         I want to be able to see any result' do
  given!(:question1) { create(:question, title: 'find_question_title', body: 'body') }
  given!(:question2) { create(:question, title: 'title1', body: 'find_question_body') }
  given!(:question3) { create(:question, title: 'other', body: 'other') }
  given!(:answer1) { create(:answer, body: 'find_answer_body') }
  given!(:answer2) { create(:answer, body: 'other') }
  given!(:comment1) { create(:comment, content: 'find_comment_body', commentable: answer1) }
  given!(:comment2) { create(:comment, content: 'other') }
  given!(:user1) { create(:user, email: 'findmeuser@mail.com') }
  given!(:user2) { create(:user, email: 'otheruser@mail.com') }

  before do
    index
    visit root_path
  end

  after do
    expect(page).not_to have_content('other')
  end

  scenario 'searching in everywhere' do
    fill_in 'query', with: 'find'
    select 'everywhere', from: 'object'
    click_button 'Search'
    expect(current_path).to eq search_index_path
    expect(page).to have_link(question1.title)
    expect(page).to have_link(question2.title)
    expect(page).to have_link(answer1.body)
    expect(page).to have_link(comment1.content)
    expect(page).to have_content(user1.email.split('@').first)
  end

  scenario 'searching for question' do
    fill_in 'query', with: 'find'
    select 'questions', from: 'object'
    click_button 'Search'
    expect(current_path).to eq search_index_path
    expect(page).to have_link(question1.title)
    expect(page).to have_link(question2.title)
  end

  scenario 'searching for answer' do
    fill_in 'query', with: 'find'
    select 'answers', from: 'object'
    click_button 'Search'
    expect(current_path).to eq search_index_path
    expect(page).to have_link(answer1.body)
  end

  scenario 'searching for comment' do
    fill_in 'query', with: 'find'
    select 'comments', from: 'object'
    click_button 'Search'
    expect(current_path).to eq search_index_path
    expect(page).to have_link(comment1.content)
  end

  scenario 'searching for user' do
    fill_in 'query', with: 'find'
    select 'users', from: 'object'
    click_button 'Search'
    expect(current_path).to eq search_index_path
    expect(page).to have_content(user1.email.split('@').first)
  end
end
