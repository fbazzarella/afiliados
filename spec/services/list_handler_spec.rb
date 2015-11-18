require 'rails_helper'

RSpec.describe ListHandler do
  let!(:now)       { Time.now.strftime('%Y%m%d%H%M%S') }
  let!(:fixture)   { File.open(File.join(Rails.root, '/spec/fixtures/', 'list.txt')) }
  let!(:file_path) { File.join(described_class::LISTS_PATH, now) }

  before { Timecop.freeze Time.zone.now }
  after  { Timecop.return }

  subject { described_class.new(fixture) }

  describe '.new' do
    it { expect(subject).to be_a(described_class) }
  end

  describe '#save_to_disk_and_import!' do
    before { subject.save_to_disk_and_import! }

    it { expect(Email.count).to be_eql(2) }
    it { expect(Email.first.address).to be_eql('mail-1@example.com') }
    it { expect(Email.last.address).to be_eql('mail-2@example.com') }
  end
end
