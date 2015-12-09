require 'rails_helper'

RSpec.describe List, type: :model do
  it { should respond_to(:file) }
  it { should respond_to(:uuid) }

  describe 'callbacks' do
    let!(:uuid)    { SecureRandom.uuid }
    let!(:fixture) { File.open(File.join(Rails.root, '/spec/fixtures/', 'list.txt')) }
    let!(:list)    { build(:list, file: fixture, uuid: uuid) }

    before :all do
      TestAfterCommit.enabled = true
    end

    after :all do
      TestAfterCommit.enabled = false
    end
    
    describe 'on create' do
      clean_lists!

      after { list.save }

      describe 'before_validation' do
        it { expect(ListHandler).to receive(:save_to_disk).with(fixture, uuid).once }
      end

      describe 'after_commit' do
        it { expect(ListImportJob).to receive(:perform_later).with(list).once }
      end
    end

    describe 'on destroy' do
      describe 'after_commit' do
        after do
          list.save
          list.destroy
        end

        it { expect(FileUtils).to receive(:rm).once }
      end
    end
  end
end
