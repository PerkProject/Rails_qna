FactoryGirl.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do
    title
    body "MyQuestionText"
    user
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
