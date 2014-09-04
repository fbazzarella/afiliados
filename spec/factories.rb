FactoryGirl.define do
  factory :user do
    username 'johndoe'
    password 'secret'
  end

  factory :email do
    sequence :address do |n|
      "mail-#{n}@example.com"
    end
  end

  factory :campaign do
    name 'Campaign Name'
  end

  factory :shot do
    email
    campaign
  end
end
