require 'rails_helper'

RSpec.describe ListHandler do
  clean_lists!

  let!(:uuid)      { SecureRandom.uuid }
  let!(:file_path) { File.join(described_class::LISTS_PATH, uuid) }
  let!(:fixture)   { File.open(File.join(Rails.root, '/spec/fixtures/', 'list.txt')) }

  describe '.save_to_disk' do
    let!(:returned_value) { described_class.save_to_disk(fixture, uuid) }

    it { expect(File.exist?(file_path)).to be_truthy }
    it { expect(returned_value).to be_eql(file_path) }
  end

  describe '.import_to_database' do
    let!(:list_import) { build(:list_import, file_path: file_path) }

    before do
      File.open(file_path, 'wb') do |f|
        f.write(described_class.send(:filter_list, fixture))
      end

      described_class.import_to_database(list_import)
    end

    describe 'redis pub/sub' do
      pending
    end

    it { expect(Email.count).to be_eql(2) }
    it { expect(Email.first.address).to be_eql('mail-1@example.com') }
    it { expect(Email.last.address).to be_eql('mail-2@example.com') }
  end
end
