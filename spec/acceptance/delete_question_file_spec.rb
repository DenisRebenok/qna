require_relative 'acceptance_helper'

feature 'deleting questions file', %q{
  In order to delete attached file
  As an author of question
  I'd like to be able delete attached file
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:foreign_question) { create(:question, user: other_user) }
  given!(:attachment) { create :attachment, attachable: question }
  given!(:attachment_2) { create :attachment, attachable: foreign_question }

  describe "Authenticated user" do
    before { sign_in(user) }

    scenario 'Author deletes file from own question', js: true do
      visit question_path(question)

      within "#question-#{question.id}" do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
        click_on 'Edit'
        click_on 'Remove file'
        click_on 'Save'
        expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
      end
    end

    scenario 'User tries to delete file from foreign question', js: true do
      visit question_path(foreign_question)

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'

      within "#question-#{foreign_question.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete file' do
    visit question_path(foreign_question)

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'

    within "#question-#{foreign_question.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end
end