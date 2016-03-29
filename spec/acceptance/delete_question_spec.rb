require 'rails_helper'

feature 'Only author can delete his question', %q{
  In order to delete question
  As an author of question
  I want to be able to delete my own question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Author deletes his own question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'Another user can not delete not his question' do
    sign_in(other_user)

    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user can not delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

end