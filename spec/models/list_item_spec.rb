require 'rails_helper'

RSpec.describe ListItem, type: :model do
  it { should belong_to(:list) }
  it { should belong_to(:email) }

  it { should have_many(:shots).dependent(:restrict_with_error) }
  it { should have_many(:campaigns).through(:shots) }

  it { should validate_presence_of(:list_id) }
  it { should validate_presence_of(:email_id) }
  it { should validate_uniqueness_of(:email_id).scoped_to(:list_id) }

  describe 'scopes' do
    describe '.valid' do
      pending
    end
  end
end
