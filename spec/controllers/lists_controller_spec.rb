require 'rails_helper'

RSpec.describe ListsController, type: :controller do
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

  describe 'POST create' do
    context 'when logged in' do
      login!
  
      def post_create
        post :create, {list: attributes_for(:list)}, format: :json
      end

      before { post_create }

      it { expect(response.body).to match("\"id\":#{List.last.id}") }

      it { is_expected.to respond_with 200 }
    end

    context 'when logged out' do
      before { post :create, format: :json }

      it { is_expected.to respond_with 401 }
    end
  end
end
