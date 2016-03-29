require 'rails_helper'

feature 'User can view questions with answers', %q{
  In order to view questions with answers
  As an user
  I want to be able to view all answers for questions
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 10, question: question) }

  scenario 'User view question with answers' do
    visit root_path
    click_link question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each { |answer| expect(page).to have_content answer.body }
  end

end