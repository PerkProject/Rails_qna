FactoryGirl.define do
  factory :answer do
    question
    body "MyAnswerText"
    user
  end

  factory :invalid_answer, class: Answer do
    question
    body nil
  end
end
