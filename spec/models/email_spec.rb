require 'rails_helper'

RSpec.describe Email, type: :model do
  it { should validate_presence_of(:address) }
  it { should allow_value('email@example.com').for(:address) }
  it { should_not allow_value('invalid.email').for(:address) }
end
