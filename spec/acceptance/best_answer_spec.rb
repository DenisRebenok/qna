require_relative 'acceptance_helper'

feature 'Setting best answer', %q{
  In order to be able to choose which answer is best
  As an author of question
  I want to be able to to set best answer
} do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:foreign_question) { create(:question) }
  given!(:other_answer) { create(:answer, question: foreign_question) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'sets best answer for his question', js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on 'Best'

        expect(page).to have_content "It's the best answer"
        expect(page).to_not have_link 'Best'
      end

    end

    scenario 'tries to set best answer for foreign question', js: true do
      visit question_path(foreign_question)

      within("#answer-#{other_answer.id}") do
        expect(page).to_not have_link 'Best'
      end
    end
  end

  scenario 'Unauthenticated user tries to set best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end

end