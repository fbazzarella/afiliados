require 'rails_helper'

RSpec.describe ListImport, type: :model do
  it { should respond_to(:file) }

  describe 'callbacks' do
    let!(:fixture)     { File.open(File.join(Rails.root, '/spec/fixtures/', 'list.txt')) }
    let!(:list_import) { build(:list_import, file: fixture) }

    describe 'on create' do
      clean_lists!

      after { list_import.save }

      describe 'before_validation' do
        it { expect(ListHandler).to receive(:save_to_disk).with(fixture).once }
      end

      describe 'after_save' do
        it { expect(ListImportJob).to receive(:perform_later).with(list_import).once }
      end
    end

    describe 'after_destroy' do
      it do
        expect(FileUtils).to receive(:rm).once
        list_import.destroy
      end
    end
  end
end
