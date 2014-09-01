FactoryGirl.define do
  factory :user do
    username 'johndoe'
    password 'secret'
  end

  factory :import_error do
    file_name 'file'
    line_number 1
    line_string 'string'
    error_messages 'error'
  end
end
