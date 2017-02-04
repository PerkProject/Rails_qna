FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    application { FactoryGirl.create(:oauth_applcation) }
    resource_owner_id { FactoryGirl.create(:user).id }
  end
end
