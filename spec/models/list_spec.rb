require 'rails_helper'

RSpec.describe List, type: :model do
  describe '#to_json' do
    let!(:list) { create(:list) }

    subject { list.to_json }

    it { expect(subject[:id]).to be_eql(list.id) }
  end

  describe 'callbacks' do
    let!(:list) { build(:list) }

    describe 'on create' do
      after { list.save }

      describe 'after_save' do
        it { expect(ListImportJob).to receive(:perform_later).with(list).once }
      end
    end
  end
end
