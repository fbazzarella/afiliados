require 'rails_helper'

RSpec.describe List, type: :model do
  it { should have_many(:list_items).dependent(:nullify) }
  it { should have_many(:emails).through(:list_items) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:file) }

  describe 'callbacks' do
    describe 'on create' do
      describe 'before_validation' do
        let!(:fixture) { File.open(File.join(Rails.root, '/spec/fixtures/list.txt')) }
        let!(:file)    { Rack::Test::UploadedFile.new(fixture) }
        let!(:list)    { create(:list, file: file) }

        it { expect(list.name).to be_eql('list.txt') }
      end
    end

    describe 'after_create' do
      let!(:list) { build(:list) }

      after { list.save }

      it { expect(ListImportJob).to receive(:perform_later).once }
    end
  end

  describe '#to_json' do
    let!(:list) { create(:list) }

    subject { list.to_json }

    it { expect(subject[:id]).to be_eql(list.id) }
  end

  describe '#to_csv' do
    pending
  end
end
