require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  render_views

  describe 'GET index' do
    context 'when logged in' do
      login!

      let!(:list) { create(:list) }

      before { get :index }

      it { expect(assigns(:lists)).to be_a(ActiveRecord::Relation) }
      it { expect(assigns(:lists)).to include(list) }

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

  describe 'DELETE destroy' do
    context 'when logged in' do
      login!

      context 'when valid id' do
        let!(:list)  { create(:list) }

        before { delete :destroy, id: list.id }

        it { expect(List.count).to be_zero }

        it { is_expected.to redirect_to(lists_path) }
      end

      context 'when invalid id' do
        it { expect{ delete :destroy, id: 1 }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end

    context 'when logged out' do
      before { delete :destroy, id: 1 }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
