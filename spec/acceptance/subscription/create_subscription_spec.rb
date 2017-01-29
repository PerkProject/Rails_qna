require_relative '../../../spec/acceptance/acceptance_helper'

feature 'create subscription' do
  let(:user) { create :user }
  let(:own_question) { create(:question, user: user) }
  let(:question) { create :question }

  context 'guest user' do
    scenario 'could not subscribe on question' do
      visit question_path(question)
      expect(page).not_to have_button('subscribe')
    end
  end

  context 'authenticated user' do
    before { sign_in(user) }

    scenario 'could subscribe on question', js: true do
      visit question_path(question)
      expect(page).to have_button 'subscribe'
      click_button('subscribe')
      expect(page).to have_link 'cancel subscription'
    end
  end
end
