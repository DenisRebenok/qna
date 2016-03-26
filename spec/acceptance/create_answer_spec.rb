require 'rails_helper'

feature 'User can write answer', %q{
  In order to be able to write answer to question
  As an user
  I want to be able to to write answer
} do

  given(:user) { create :user }
  given!(:question) { create :question }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    create_answer(question, 'stupid answer')

    expect(page).to have_content 'Answer was successfully created.'
    expect(page).to have_content 'stupid answer'
  end

  scenario 'Authenticated user creates answer with invalid attributes' do
    sign_in(user)

    create_answer(question, '')

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Error was happened when trying to save answer.'
  end

  scenario 'Non-authenticated user tries to create answer' do
    create_answer(question, '')

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end