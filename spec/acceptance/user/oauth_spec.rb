require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Oauth user sign in', %q{
  User able to sign in with his social network account
} do
  scenario 'sign in with oauth provider' do
    ['Facebook', 'Twitter'].each do |provider|
      visit new_user_session_path
      expect(page).to have_content("Sign in with #{provider}"), match: :first
      mock_auth_hash(provider)
      click_on "Sign in with #{provider}", match: :first

      expect(page).to have_content("Successfully authenticated from #{provider} account.")
      click_on('Exit')
      expect(page).to have_content("Signed out successfully.")
    end
  end

  scenario 'try to sign in with invalid oauth provider', js: true do
    ['Facebook', 'Twitter'].each do |provider|
      visit new_user_session_path
      expect(page).to have_content("Sign in with #{provider}"), match: :first
      invalid_mock_auth_hash(provider)
      click_on "Sign in with #{provider}", match: :first

      expect(page).to have_content("Could not authenticate you from #{provider} because \"Invalid credentials\".")
    end
  end

end