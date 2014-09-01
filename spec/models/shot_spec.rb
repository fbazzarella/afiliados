require 'rails_helper'

RSpec.describe Shot, type: :model do
  it { should belong_to(:email) }
  it { should belong_to(:campaign) }

  it { should delegate_method(:verified_at).to(:email) }

  it { should validate_presence_of(:email_id) }
  it { should validate_presence_of(:campaign_id) }
end
