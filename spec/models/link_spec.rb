require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:shot) }

  it { should validate_presence_of(:url) }
end
