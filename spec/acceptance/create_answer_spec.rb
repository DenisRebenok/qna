require_relative 'acceptance_helper'

feature 'User can write answer', %q{
  In order to be able to write answer to question
  As an user
  I want to be able to to write answer
} do

  given(:user) { create :user }
  given!(:question) { create :question }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)

    create_answer(question, 'stupid answer')

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Answer was successfully created.'
    within '.answers' do
      expect(page).to have_content 'stupid answer'
    end
  end

  scenario 'Authenticated user creates answer with invalid attributes', js: true do
    sign_in(user)

    create_answer(question, '')

    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create answer' do
    create_answer(question, '')

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end