FactoryGirl.define do
  factory :campaign do
    name    'Campaign Name'
    subject 'Campaign Subject'
  end

  factory :email do
    sequence :address do |n|
      "mail-#{n}@example.com"
    end
  end

  factory :shot do
    email
    campaign
  end

  factory :shot_event do
    service    'service-name'
    event      'delivered'
    event_hash Hash.new('event' => 'delivered')
  end

  factory :user do
    username 'johndoe'
    password 'secret'
  end
end
