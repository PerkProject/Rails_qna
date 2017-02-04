FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.sentence(3) }
    user
    association :commentable, factory: :question

    factory :invalid_comment do
      content ' '
    end
  end
end
