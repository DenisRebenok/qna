FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "My #{n} Text" }
    question
    user
  end

  factory :invalid_answer, class: Answer do
    body nil
    question nil
    user
  end
end
