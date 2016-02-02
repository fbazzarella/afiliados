require 'rails_helper'

RSpec.describe Email, type: :model do
  it { should have_many(:list_items).dependent(:restrict_with_error) }
  it { should have_many(:lists).through(:list_items) }

  it { should validate_presence_of(:address) }
  it { should validate_uniqueness_of(:address) }
  it { should allow_value('email@example.com').for(:address) }
  it { should_not allow_value('invalid.email').for(:address) }

  it { should allow_value('Ok').for(:verification_result) }
  it { should allow_value('Bad').for(:verification_result) }
  it { should allow_value(nil).for(:verification_result) }
  it { should_not allow_value('Other').for(:verification_result) }

  describe 'scopes' do
    let!(:valid)   { create(:email, verification_result: 'Ok') }
    let!(:invalid) { create(:email, verification_result: 'Bad') }
    let!(:unknown) { create(:email) }

    describe '.valid' do
      it { expect(described_class.valid).to include(valid) }
      it { expect(described_class.valid).to_not include(invalid) }
      it { expect(described_class.valid).to_not include(unknown) }
    end

    describe '.invalid' do
      it { expect(described_class.invalid).to_not include(valid) }
      it { expect(described_class.invalid).to include(invalid) }
      it { expect(described_class.invalid).to_not include(unknown) }
    end

    describe '.unknown' do
      it { expect(described_class.unknown).to_not include(valid) }
      it { expect(described_class.unknown).to_not include(invalid) }
      it { expect(described_class.unknown).to include(unknown) }
    end
  end
end
