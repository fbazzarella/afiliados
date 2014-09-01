require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { should have_many(:shots) }
  it { should have_many(:emails).through(:shots) }

  it { should validate_presence_of(:name) }
end
