require 'rails_helper'

RSpec.describe ShotEvent, type: :model do
  it { should belong_to(:shot) }

  it { should validate_presence_of(:shot_id) }
  it { should validate_presence_of(:service) }
  it { should validate_presence_of(:event) }
  it { should validate_presence_of(:event_hash) }
end
