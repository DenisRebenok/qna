require_relative 'acceptance_helper'

feature 'deleting answer file', %q{
  In order to delete attached file
  As an author of answer
  I'd like to be able delete attached file
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:foreign_answer) { create(:answer, question: question, user: other_user) }
  given!(:attachment) { create :attachment, attachable: answer }
  given!(:attachment_2) { create :attachment, attachable: foreign_answer }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Author deletes file from own answer', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
        click_on 'Edit'
        click_on 'Remove file'
        click_on 'Save'
        expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
      end
    end

    scenario 'User tries to delete file from foreign answer', js: true do
      within "#answer-#{foreign_answer.id}" do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete file' do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to_not have_link 'Edit'
    end
  end
end