FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email-#{n}@example.com" }
    password 'test1234'

    first_name "Foo"
    last_name  "Bar"

    factory :user_with_provider do
      after(:create) do |u|
        u.auth_providers << FactoryGirl.build(:facebook_auth_provider, provider_account_id: u.id)
      end
    end
  end
end
