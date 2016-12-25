require_relative '../../../spec/acceptance/acceptance_helper'

feature 'Oauth user sign in', %q{
  User able to sign in with his social network account
} do

  scenario 'sign in with oauth provider' do
    ['Facebook', 'Twitter'].each do |provider|
      clear_emails
      email = "name@mail-12345-#{provider.downcase}.com"


      mock_auth_hash(provider)
      visit new_user_session_path

      expect(page).to have_content("Sign in with #{provider}"), match: :first
      click_on "Sign in with #{provider}", match: :first

      expect(page).to have_content 'Provide your email'
      fill_in 'Email', with: email
      click_on 'Continue'

      open_email(email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'

      click_on "Sign in with #{provider}", match: :first

      expect(page).to have_content("Successfully authenticated from #{provider} account.")

      click_on('Exit')
      expect(page).to have_content("Signed out successfully.")

      click_on "Sign in with #{provider}"
      expect(page).to have_content("Successfully authenticated from #{provider} account.")

      click_on('Exit')
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