require_relative '../../../spec/acceptance/acceptance_helper'

feature 'User sign up', %q{
In order to be able to requires authentication
As an non-registered User
I want to be able to sign up
} do

  scenario 'Unregistered user can sign up and success' do
    clear_emails
    visit new_user_registration_path

    click_on('Sign up' , :match => :first)

    fill_in 'Email', with: 'usertest@email.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_button('Sign up' , :match => :first)

    open_email('usertest@email.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content "Your email address has been successfully confirmed."

    end


end