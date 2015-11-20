require 'rails_helper'

RSpec.describe Email, type: :model do
  it { should have_many(:shots).dependent(:restrict_with_error) }
  it { should have_many(:campaigns).through(:shots) }

  it { should validate_presence_of(:address) }
  it { should validate_uniqueness_of(:address) }
  it { should allow_value('email@example.com').for(:address) }
  it { should_not allow_value('invalid.email').for(:address) }

  it { should allow_value('Ok').for(:verification_result) }
  it { should allow_value('Bad').for(:verification_result) }
  it { should allow_value(nil).for(:verification_result) }
  it { should_not allow_value('Other').for(:verification_result) }

  describe 'scopes' do
    describe '.valid' do
      let!(:valid_email) { create(:email, verification_result: 'Ok') }
      let!(:not_valid_email) { create(:email) }

      it { expect(described_class.valid).to include(valid_email) }
      it { expect(described_class.valid).to_not include(not_valid_email) }
    end
  end
end
