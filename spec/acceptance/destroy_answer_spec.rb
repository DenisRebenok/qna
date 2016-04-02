require_relative 'acceptance_helper'

feature 'Only author can delete his answer', %q{
  In order to delete answer
  As an author of answer
  I want to be able to delete my own answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:foreign_answer) { create(:answer, question: question) }

  describe "Authenticated author" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to Delete answer' do
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Delete answer'
      end
    end

    scenario 'deletes his answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Delete answer'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete other user's answer" do
      within "#answer-#{foreign_answer.id}" do
        expect(page).to_not have_link 'Delete answer'
      end
    end
  end

  scenario 'Non-authenticated user can not delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end