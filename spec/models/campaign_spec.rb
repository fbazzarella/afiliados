require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { should belong_to(:newsletter) }

  it { should have_many(:shots).dependent(:nullify) }
  it { should have_many(:list_items).through(:shots) }

  it { should validate_presence_of(:name) }

  describe '#prepare_chase!' do
    pending
  end

  describe '#chase!' do
    pending

    # let!(:campaign) { create(:campaign) }

    # it { expect{ campaign.chase! }.to change(Sidekiq::Extensions::DelayedModel.jobs, :size).by(1) }
  end

  describe 'private methods' do
    describe '#increase_chase' do
      pending
    end

  #   describe '#decrease_chase' do
  #     let!(:queued_shot) { create(:shot, queued_at: Time.current) }
  #     let!(:unqueued_shot) { create(:shot, queued_at: nil) }
  #     let!(:campaign) { create(:campaign, shots: [queued_shot, unqueued_shot]) }

  #     context 'when have shots to decrease' do
  #       it { expect{ campaign.send(:decrease_chase, 0) }.to change(campaign.shots, :count).by(-1) }
  #       it { expect{ campaign.send(:decrease_chase, 1) }.to change(campaign.shots, :count).by(-1) }
  #     end

  #     context 'when have not shots to decrease' do
  #       it { expect{ campaign.send(:decrease_chase, 2) }.to_not change(campaign.shots, :count) }
  #     end
  #   end

    describe '#chase' do
      pending

  #     let!(:queued_shot) { create(:shot, queued_at: Time.current) }
  #     let!(:unqueued_shot) { create(:shot, queued_at: nil) }
  #     let!(:campaign) { create(:campaign, shots: [queued_shot, unqueued_shot]) }

  #     it { expect{ campaign.send(:chase) }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1) }
  #     it { expect{ campaign.send(:chase); unqueued_shot.reload }.to change(unqueued_shot, :queued_at) }
    end
  end
end
