FactoryGirl.define do
  factory :answer do
    question
    sequence(:body) { |n| "MyAnswerText#{n}" }
    user
  end

  factory :invalid_answer, class: Answer do
    user
    question
    body nil
  end
end
