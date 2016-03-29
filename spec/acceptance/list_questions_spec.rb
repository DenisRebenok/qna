require 'rails_helper'

feature 'User can view all questions', %q{
  In order to view all questions
  As an user
  I want to be able to view all questions
} do

  given!(:questions) { create_list(:question, 10) }

  scenario 'view all questions' do
    visit root_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end