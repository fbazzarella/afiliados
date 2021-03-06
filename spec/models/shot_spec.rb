require 'rails_helper'

RSpec.describe Shot, type: :model do
  it { should belong_to(:list_item) }
  it { should belong_to(:campaign) }

  it { should have_many(:shot_events).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of(:list_item_id) }
  it { should validate_presence_of(:campaign_id) }
  it { should validate_uniqueness_of(:list_item_id).scoped_to(:campaign_id) }

  describe 'scopes' do
    describe '.queued' do
      let!(:queued_shot) { create(:shot, queued_at: Time.current) }
      let!(:unqueued_shot) { create(:shot, queued_at: nil) }

      it { expect(described_class.queued).to_not include(unqueued_shot) }
      it { expect(described_class.queued).to include(queued_shot) }
    end

    describe '.unqueued' do
      let!(:queued_shot) { create(:shot, queued_at: Time.current) }
      let!(:unqueued_shot) { create(:shot, queued_at: nil) }

      it { expect(described_class.unqueued).to include(unqueued_shot) }
      it { expect(described_class.unqueued).to_not include(queued_shot) }
    end

    describe '.relayed' do
      let!(:relayed_shot) { create(:shot, relayed_at: Time.current) }
      let!(:unrelayed_shot) { create(:shot, relayed_at: nil) }

      it { expect(described_class.relayed).to_not include(unrelayed_shot) }
      it { expect(described_class.relayed).to include(relayed_shot) }
    end

    describe '.unrelayed' do
      let!(:relayed_shot) { create(:shot, relayed_at: Time.current) }
      let!(:unrelayed_shot) { create(:shot, relayed_at: nil) }

      it { expect(described_class.unrelayed).to include(unrelayed_shot) }
      it { expect(described_class.unrelayed).to_not include(relayed_shot) }
    end

    describe '.opened' do
      let!(:opened_shot) { create(:shot, opened_at: Time.current) }
      let!(:unopened_shot) { create(:shot, opened_at: nil) }

      it { expect(described_class.opened).to_not include(unopened_shot) }
      it { expect(described_class.opened).to include(opened_shot) }
    end

    describe '.unopened' do
      let!(:opened_shot) { create(:shot, opened_at: Time.current) }
      let!(:unopened_shot) { create(:shot, opened_at: nil) }

      it { expect(described_class.unopened).to include(unopened_shot) }
      it { expect(described_class.unopened).to_not include(opened_shot) }
    end

    describe '.clicked' do
      let!(:clicked_shot) { create(:shot, clicked_at: Time.current) }
      let!(:unclicked_shot) { create(:shot, clicked_at: nil) }

      it { expect(described_class.clicked).to_not include(unclicked_shot) }
      it { expect(described_class.clicked).to include(clicked_shot) }
    end

    describe '.unclicked' do
      let!(:clicked_shot) { create(:shot, clicked_at: Time.current) }
      let!(:unclicked_shot) { create(:shot, clicked_at: nil) }

      it { expect(described_class.unclicked).to include(unclicked_shot) }
      it { expect(described_class.unclicked).to_not include(clicked_shot) }
    end

    describe '.unsubscribed' do
      let!(:unsubscribed_shot) { create(:shot, unsubscribed_at: Time.current) }
      let!(:subscribed_shot) { create(:shot, unsubscribed_at: nil) }

      it { expect(described_class.unsubscribed).to_not include(subscribed_shot) }
      it { expect(described_class.unsubscribed).to include(unsubscribed_shot) }
    end

    describe '.subscribed' do
      let!(:unsubscribed_shot) { create(:shot, unsubscribed_at: Time.current) }
      let!(:subscribed_shot) { create(:shot, unsubscribed_at: nil) }

      it { expect(described_class.subscribed).to include(subscribed_shot) }
      it { expect(described_class.subscribed).to_not include(unsubscribed_shot) }
    end
  end

  describe '.postback' do
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

    describe '.sendgrid_params' do
      let!(:params) { {'_json' => [{'event' => 'delivered'}]} }

      it { expect(described_class.send(:sendgrid_params, params)).to be_eql(expected_params) }
    end

    describe '.mailgun_params' do
      let!(:params) { {'event' => 'delivered'} }

      it { expect(described_class.send(:mailgun_params, params)).to be_eql(expected_params) }
    end

    describe '#shoot!' do
      let!(:shot) { create(:shot) }

      it { expect{ shot.send(:shoot!) }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1) }
      it { expect{ shot.send(:shoot!); shot.reload }.to change(shot, :queued_at) }
    end
  end
end
