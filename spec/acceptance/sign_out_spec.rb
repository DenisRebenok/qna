require_relative 'acceptance_helper'

feature 'User sign_out', %q{
  In order to be able to sign out
  As an authenticated user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)
    click_link 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-authenticated user try to sign out' do
    visit root_path
    expect(page).to_not have_link 'Sign out'
  end
end