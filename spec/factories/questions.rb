FactoryGirl.define do
  sequence :title do |n|
    "My #{n} String"
  end

  sequence :body do |n|
    "My #{n} Text"
  end

  factory :question do
    title
    body
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
