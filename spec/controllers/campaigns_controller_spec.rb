require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  render_views

  describe 'GET index' do
    context 'when logged in' do
      login!

      before { get :index }

      it { is_expected.to respond_with 200 }
    end

    context 'when logged out' do
      before { get :index }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe 'POST list_upload' do
    context 'when logged in' do
      login!

      let!(:file_path) { File.join(Rails.root, '/spec/fixtures/', 'list.txt') }
      let!(:fixture)   { Rack::Test::UploadedFile.new(File.open(file_path)) }

      def post_list_upload
        post :list_upload, {list: fixture}, format: :json
      end

      before { post_list_upload }

      it do
        expect(ListImport).to receive(:create).with(file: fixture).once
        post_list_upload
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when logged out' do
      before { post :list_upload, format: :json }

      it { is_expected.to respond_with 401 }
    end
  end
end
