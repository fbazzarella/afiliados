require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }
  it { should validate_confirmation_of(:password) }
  it { should validate_length_of(:password).is_at_least(6).is_at_most(24) }
end
