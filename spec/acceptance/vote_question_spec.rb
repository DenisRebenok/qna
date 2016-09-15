require_relative 'acceptance_helper'

feature 'user can vote for question', %q{
  In order to select best question
  As a registered user
  I can to vote for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote up for question', js: true do
      expect(page).to have_css('.object-vote-result', text: '0')

      click_on 'vote up'

      expect(page).to have_css('.object-vote-result', text: '1')
      expect(current_path).to eq question_path(question)
    end

    scenario 'can vote down for question', js: true do
      expect(page).to have_css('.object-vote-result', text: '0')

      click_on 'vote down'

      expect(page).to have_css('.object-vote-result', text: '-1')
      expect(current_path).to eq question_path(question)
    end

    scenario 'cannot vote for own questions', js: true do
      visit question_path(user_question)

      expect(page).not_to have_link('vote up')
      expect(page).not_to have_link('vote down')
    end

    scenario 'can vote for question only once', js: true do
      click_on 'vote up'

      expect(page).to have_css('.object-vote-result', text: '1')
      expect(page).not_to have_link('vote up')
      expect(page).not_to have_link('vote down')
    end

    scenario 'can revoke vote', js: true do
      expect(page).not_to have_link('revoke vote')

      click_on 'vote up'

      expect(page).to have_link('revoke vote')

      click_on 'revoke vote'

      expect(page).not_to have_link('revoke vote')
      expect(page).to have_link('vote up')
      expect(page).to have_link('vote down')
    end
  end

  describe 'not authenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'cannot vote for the question', js: true do
      expect(page).not_to have_link('vote up')
      expect(page).not_to have_link('vote down')
      expect(page).not_to have_link('revoke vote')
    end
  end
end