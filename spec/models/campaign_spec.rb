require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { should have_many(:shots).dependent(:restrict_with_error) }
  it { should have_many(:emails).through(:shots) }

  it { should validate_presence_of(:name) }

  describe '.chase!' do
    let!(:queued_shot) { create(:shot, queued_at: Time.zone.now) }
    let!(:unqueued_shot) { create(:shot, queued_at: nil) }
    let!(:campaign) { create(:campaign, shots: [queued_shot, unqueued_shot]) }

    it { expect { campaign.chase! }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1) }
    it { expect { campaign.chase!; unqueued_shot.reload }.to change(unqueued_shot, :queued_at) }
  end
end
