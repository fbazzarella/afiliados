require 'rails_helper'

RSpec.describe Shot, type: :model do
  it { should belong_to(:email) }
  it { should belong_to(:campaign) }
  it { should have_many(:shot_events).dependent(:restrict_with_error) }

  it { should validate_presence_of(:email_id) }
  it { should validate_presence_of(:campaign_id) }

  it { should validate_uniqueness_of(:email_id).scoped_to(:campaign_id) }

  describe 'scopes' do
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
  end

  describe '#postback' do
    let!(:shot) { create(:shot) }

    context 'when service is sendgrid' do
      let!(:events) { [{'shot_id' => shot.id, 'event' => 'delivered'}] }

      before { described_class.postback(events, 'sendgrid') }

      it { expect(shot.shot_events.first.service).to be_eql('sendgrid') }
      it { expect(shot.shot_events.first.event).to be_eql('delivered') }
      it { expect(shot.shot_events.first.event_hash['event']).to be_eql('delivered') }
      it { expect{ described_class.postback(events, 'service') }.to change(shot.shot_events, :count).by(1) }
    end

    context 'when service is mailgun' do
      let!(:events) { [{'X-Mailgun-Variables' => {'shot_id' => shot.id}, 'event' => 'delivered'}] }

      before { described_class.postback(events, 'mailgun') }

      it { expect(shot.shot_events.first.service).to be_eql('mailgun') }
      it { expect(shot.shot_events.first.event).to be_eql('delivered') }
      it { expect(shot.shot_events.first.event_hash['event']).to be_eql('delivered') }
      it { expect{ described_class.postback(events, 'service') }.to change(shot.shot_events, :count).by(1) }
    end

    context 'when invalid shot id' do
      it { expect{ described_class.postback([{'shot_id' => 0}], 'service') }.to_not change(ShotEvent, :count) }
    end
  end
end
