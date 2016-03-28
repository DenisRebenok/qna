FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer body text #{n}" }
    question
    user
  end

  factory :invalid_answer, class: Answer do
    body nil
    question nil
    user
  end
end
