require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:foreign_answer) { create :answer }

  describe "Authenticated user" do
    before { sign_in user }

    scenario 'try to edit his answer', js: true do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "try to edit other user's answer" do
      visit question_path(foreign_answer.question)

      within "#answer-#{foreign_answer.id}" do
        expect(page).to_not have_link('Edit')
      end
    end
  end

  scenario 'Unauthenticated user try to edit answer' do
     visit question_path(question)
     expect(page).to_not have_link 'Edit'
  end
end