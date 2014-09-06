require 'rails_helper'

RSpec.describe Shot, type: :model do
  it { should belong_to(:email) }
  it { should belong_to(:campaign) }
  it { should have_many(:shot_events).dependent(:restrict_with_error) }

  it { should validate_presence_of(:email_id) }
  it { should validate_presence_of(:campaign_id) }

  it { should validate_uniqueness_of(:email_id).scoped_to(:campaign_id) }

  describe '#queued' do
    let!(:queued_shot) { create(:shot, queued_at: Time.zone.now) }
    let!(:unqueued_shot) { create(:shot, queued_at: nil) }

    it { expect(described_class.queued).to_not include(unqueued_shot) }
    it { expect(described_class.queued).to include(queued_shot) }
  end

  describe '#unqueued' do
    let!(:queued_shot) { create(:shot, queued_at: Time.zone.now) }
    let!(:unqueued_shot) { create(:shot, queued_at: nil) }

    it { expect(described_class.unqueued).to include(unqueued_shot) }
    it { expect(described_class.unqueued).to_not include(queued_shot) }
  end

  describe '#postback' do
    let!(:shot) { create(:shot) }

    it do
      %w(delivered bounce deferred dropped click open spamreport unsubscribe).each do |e|
        events = [{'shot_id' => shot.id, 'event' => e}]
        expect{ described_class.postback(events); shot.reload }.to change(shot, "#{e}_at".to_sym)
      end
    end

    it do
      events = [{'shot_id' => shot.id, 'event' => 'other_event'}]
      expect{ described_class.postback(events) }.to raise_error(NoMethodError)
    end
  end
end
