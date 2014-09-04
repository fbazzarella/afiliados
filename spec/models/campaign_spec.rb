require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { should have_many(:shots).dependent(:restrict_with_error) }
  it { should have_many(:emails).through(:shots) }

  it { should validate_presence_of(:name) }

  describe '#postback' do
    let!(:shot) { create(:shot) }

    it do
      %w(delivered bounce deferred dropped click open spamreport unsubscribe).each do |e|
        events = [{'shot_id' => shot.id, 'event' => e}]
        expect{ Campaign.postback(events); shot.reload }.to change(shot, "#{e}_at".to_sym)
      end
    end

    it do
      events = [{'shot_id' => shot.id, 'event' => 'other_event'}]
      expect{ Campaign.postback(events) }.to raise_error(NoMethodError)
    end
  end
end
