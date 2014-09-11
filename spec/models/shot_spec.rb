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

    describe '#relayed' do
      let!(:relayed_shot) { create(:shot, relayed_at: Time.zone.now) }
      let!(:unrelayed_shot) { create(:shot, relayed_at: nil) }

      it { expect(described_class.relayed).to_not include(unrelayed_shot) }
      it { expect(described_class.relayed).to include(relayed_shot) }
    end

    describe '#unrelayed' do
      let!(:relayed_shot) { create(:shot, relayed_at: Time.zone.now) }
      let!(:unrelayed_shot) { create(:shot, relayed_at: nil) }

      it { expect(described_class.unrelayed).to include(unrelayed_shot) }
      it { expect(described_class.unrelayed).to_not include(relayed_shot) }
    end
  end

  describe '#postback' do
    context 'when valid service' do
      context 'when valid shot id' do
        let!(:shot) { create(:shot) }
        let!(:params) { {'service' => 'mailgun', 'shot_id' => shot.id, 'event' => 'delivered'} }

        before { described_class.postback(params) }

        it { expect(shot.shot_events.first.service).to be_eql('mailgun') }
        it { expect(shot.shot_events.first.event).to be_eql('delivered') }
        it { expect(shot.shot_events.first.event_hash['event']).to be_eql('delivered') }
      end

      context 'when invalid shot id' do
        let!(:params) { {'service' => 'mailgun', 'shot_id' => 0, 'event' => 'delivered'} }

        it { expect{ described_class.postback(params) }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end

    context 'when invalid service' do
      it { expect(described_class.postback({'service' => 'other'})).to be_eql(false) }
    end
  end

  describe 'private methods' do
    let!(:expected_params) { [{'event' => 'delivered'}] }

    describe '#sendgrid_params' do
      let!(:params) { {'_json' => [{'event' => 'delivered'}]} }

      it { expect(described_class.send(:sendgrid_params, params)).to be_eql(expected_params) }
    end

    describe '#mailgun_params' do
      let!(:params) { {'event' => 'delivered'} }

      it { expect(described_class.send(:mailgun_params, params)).to be_eql(expected_params) }
    end
  end
end
