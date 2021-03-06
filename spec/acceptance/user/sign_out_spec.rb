require_relative '../../../spec/acceptance/acceptance_helper'

feature 'User can sign out', '
In order to be able to exit from site
As signed-in User
I want to be able to sign out
' do

  given(:user) { create(:user) }

  scenario 'authenticated user can sign out' do
    sign_in(user)
    visit questions_path

    expect(page).to have_selector(:link_or_button, 'Exit')
    click_on 'Exit'
    expect(page).to have_content('Signed out successfully.')
  end
end
