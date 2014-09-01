require 'rails_helper'

RSpec.describe ImportError, type: :model do
  it { should validate_presence_of(:file_name) }
  it { should validate_presence_of(:line_number) }
  it { should validate_presence_of(:line_string) }
  it { should validate_presence_of(:error_messages) }

  it { should validate_numericality_of(:line_number) }

  describe '.resume' do
    subject { described_class.resume }

    before do
      %w(import error error).each do |e|
        create(:import_error, error_messages: e)
      end
    end

    it { expect(subject).to be_a(Hash) }
    it { expect(subject['import']).to eql(1) }
    it { expect(subject['error']).to eql(2) }
    it { expect(subject['other']).to be_nil }
  end
end
