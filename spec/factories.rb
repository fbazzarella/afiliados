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

  factory :list do
    file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/list.txt')))
  end

  factory :list_item do
    list
    email
  end

  factory :newsletter do
    from    'From Name <mail-1@example.com>'
    subject 'Newsletter Subject'
    body    '<h1>Newsletter Body</h1>'
  end

  factory :shot do
    list_item
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
