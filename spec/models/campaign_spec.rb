require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { should have_many(:shots).dependent(:restrict_with_error) }
  it { should have_many(:emails).through(:shots) }

  it { should validate_presence_of(:name) }

  describe '.prepare_chase!' do
    let!(:shot) { create(:shot) }
    let!(:campaign) { create(:campaign, shots: [shot]) }

    it { expect{ campaign.prepare_chase!(2) }.to change(Sidekiq::Extensions::DelayedModel.jobs, :size).by(1) }
    it { expect{ campaign.prepare_chase!(0) }.to change(Sidekiq::Extensions::DelayedModel.jobs, :size).by(1) }
    it { expect{ campaign.prepare_chase!(1) }.to_not change(Sidekiq::Extensions::DelayedModel.jobs, :size) }
    it { expect{ campaign.prepare_chase! }.to raise_error(ArgumentError) }
  end

  describe '.chase!' do
    let!(:campaign) { create(:campaign) }

    it { expect{ campaign.chase! }.to change(Sidekiq::Extensions::DelayedModel.jobs, :size).by(1) }
  end

  describe 'private methods' do
    describe '.increase_chase' do
      context 'when have shots to increase' do
        let!(:email) { create(:email) }
        let!(:campaign) { create(:campaign) }

        it { expect{ campaign.send(:increase_chase, 1) }.to change(campaign.shots, :count).by(1) }
        it { expect{ campaign.send(:increase_chase, 2) }.to change(campaign.shots, :count).by(1) }
      end

      context 'when have not shots to increase' do
        let!(:shot) { create(:shot) }
        let!(:campaign) { create(:campaign, shots: [shot]) }

        it { expect{ campaign.send(:increase_chase, 1) }.to_not change(campaign.shots, :count) }
      end
    end

    describe '.decrease_chase' do
      let!(:queued_shot) { create(:shot, queued_at: Time.zone.now) }
      let!(:unqueued_shot) { create(:shot, queued_at: nil) }
      let!(:campaign) { create(:campaign, shots: [queued_shot, unqueued_shot]) }

      context 'when have shots to decrease' do
        it { expect{ campaign.send(:decrease_chase, 0) }.to change(campaign.shots, :count).by(-1) }
        it { expect{ campaign.send(:decrease_chase, 1) }.to change(campaign.shots, :count).by(-1) }
      end

      context 'when have not shots to decrease' do
        it { expect{ campaign.send(:decrease_chase, 2) }.to_not change(campaign.shots, :count) }
      end
    end

    describe '.chase' do
      let!(:queued_shot) { create(:shot, queued_at: Time.zone.now) }
      let!(:unqueued_shot) { create(:shot, queued_at: nil) }
      let!(:campaign) { create(:campaign, shots: [queued_shot, unqueued_shot]) }

      it { expect{ campaign.send(:chase) }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1) }
      it { expect{ campaign.send(:chase); unqueued_shot.reload }.to change(unqueued_shot, :queued_at) }
    end
  end
end
