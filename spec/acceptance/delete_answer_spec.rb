require 'rails_helper'

feature 'Only author can delete his answer', %q{
  In order to delete answer
  As an author of answer
  I want to be able to delete my own answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author deletes his own answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content answer.body

    click_on 'Delete answer'

    expect(page).to have_content 'Your answer successfully deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Another user can not delete not his answer' do
    sign_in(other_user)

    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Non-authenticated user can not delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end