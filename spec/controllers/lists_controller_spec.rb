require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  render_views

  describe 'POST upload' do
    context 'when logged in' do
      login!

      let!(:file_path) { File.join(Rails.root, '/spec/fixtures/', 'list.txt') }
      let!(:fixture)   { Rack::Test::UploadedFile.new(File.open(file_path)) }

      def post_upload
        post :upload, {list: fixture}, format: :json
      end

      before { post_upload }

      it do
        expect(ListImport).to receive(:create).with(file: fixture).once
        post_upload
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when logged out' do
      before { post :upload, format: :json }

      xit { is_expected.to respond_with 401 }
    end
  end

  describe 'POST import_progress' do
    pending
  end
end
