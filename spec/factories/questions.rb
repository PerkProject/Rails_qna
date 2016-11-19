FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyQuestionText"
    user
  end
  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
