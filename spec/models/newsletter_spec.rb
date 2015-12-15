require 'rails_helper'

RSpec.describe Newsletter, type: :model do
  it { should have_many(:campaigns).dependent(:restrict_with_error) }
end
