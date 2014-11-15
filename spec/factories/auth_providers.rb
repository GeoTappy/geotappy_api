FactoryGirl.define do
  factory :auth_provider do
    token 'test1234'

    factory :facebook_auth_provider do
      provider 'facebook'
    end
  end
end

