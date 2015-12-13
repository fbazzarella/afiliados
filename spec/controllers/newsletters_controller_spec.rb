require 'rails_helper'

RSpec.describe NewslettersController, type: :controller do

  describe 'GET index' do
    context 'when logged in' do
      login!

      let!(:newsletter) { create(:newsletter) }

      before { get :index }

      it { expect(assigns(:newsletters)).to be_a(ActiveRecord::Relation) }
      it { expect(assigns(:newsletters)).to include(newsletter) }

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
  
      def post_create(params = {})
        post :create, newsletter: attributes_for(:newsletter).merge!(params)
      end

      context 'when valid attributes' do
        before { post_create }

        it { expect(Newsletter.count).to_not be_zero }
        it { is_expected.to redirect_to(newsletters_path) }
      end

      # context 'when invalid attributes' do
      #   before { post_create(from: '') }

      #   it { expect(Newsletter.count).to be_zero }
      #   it { expect(assigns(:newsletters)).to be_a_new(Newsletter) }
      #   it { is_expected.to respond_with 200 }
      # end
    end

    context 'when logged out' do
      before { post :create }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe 'DELETE destroy' do
    context 'when logged in' do
      login!

      context 'when valid id' do
        let!(:newsletter)  { create(:newsletter) }

        before { delete :destroy, id: newsletter.id }

        it { expect(Newsletter.count).to be_zero }

        it { is_expected.to redirect_to(newsletters_path) }
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
