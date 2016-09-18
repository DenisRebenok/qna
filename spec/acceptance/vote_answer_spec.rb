require_relative 'acceptance_helper'

feature 'user can vote for answer', %q{
  In order to select best answer
  As a registered user
  I can to vote for answer
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:another_question) { create(:question) }

  given!(:answer) { create(:answer, user: another_user, question: question) }
  given!(:user_answer) { create(:answer, user: user, question: another_question) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote up for question', js: true do
      within '.answer .vote-control' do
        expect(page).to have_css('.object-vote-result', text: '0')

        click_on 'vote up'

        expect(page).to have_css('.object-vote-result', text: '1')
        expect(current_path).to eq question_path(question)
      end
    end

    scenario 'can vote down for question', js: true do
      within '.answer .vote-control' do
        expect(page).to have_css('.object-vote-result', text: '0')

        click_on 'vote down'

        expect(page).to have_css('.object-vote-result', text: '-1')
        expect(current_path).to eq question_path(question)
      end
    end

    scenario 'cannot vote for own questions', js: true do
      within '.answer .vote-control' do
        visit question_path(another_question)

        expect(page).not_to have_link('vote up')
        expect(page).not_to have_link('vote down')
        expect(page).not_to have_link('revoke vote')
      end
    end

    scenario 'can vote for question only once', js: true do
      within '.answer .vote-control' do
        click_on 'vote up'

        expect(page).to have_css('.object-vote-result', text: '1')
        expect(page).not_to have_link('vote up')
        expect(page).not_to have_link('vote down')
      end
    end

    scenario 'can revoke vote', js: true do
      within '.answer .vote-control' do
        expect(page).not_to have_link('revoke vote')

        click_on 'vote up'

        expect(page).to have_link('revoke vote')

        click_on 'revoke vote'

        expect(page).not_to have_link('revoke vote')
        expect(page).to have_link('vote up')
        expect(page).to have_link('vote down')
      end
    end
  end

  describe 'not authenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'cannot vote for the answer', js: true do
      expect(page).not_to have_link('vote up')
      expect(page).not_to have_link('vote down')
      expect(page).not_to have_link('revoke vote')
    end
  end
end