require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:foreign_question) { create(:question) }

  describe "Authenticated user" do
    before { sign_in(user) }

    scenario 'try to edit his question', js: true do
      visit question_path(question)

      within "#question-#{question.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "try to edit other user's question" do
      visit question_path(foreign_question)

      within "#question-#{foreign_question.id}" do
        expect(page).to_not have_link('Edit')
      end
    end
  end

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end