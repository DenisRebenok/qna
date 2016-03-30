require_relative 'acceptance_helper'

feature 'User sign_up', %q{
  In order to be able to sign up
  As an new user
  I want to be able to register
} do

  given(:user) { build(:user) }
  given(:registered_user) { create(:user) }

  scenario 'New user try to sign up with valid data' do
    sign_up(user)

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registered user try to sign up again' do
    sign_up(registered_user)

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'invalid data' do
    sign_up(User.new(email: '', password: '', password_confirmation: ''))

    expect(page).to have_content 'errors prohibited this user from being saved'
  end
end