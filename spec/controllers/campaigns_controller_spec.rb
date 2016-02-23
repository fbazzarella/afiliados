require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  render_views

  describe 'GET index' do
    context 'when logged in' do
      login!

      let!(:campaign) { create(:campaign) }

      before { get :index }

      it { expect(assigns(:campaigns)).to be_a(ActiveRecord::Relation) }
      it { expect(assigns(:campaigns)).to include(campaign) }

      it { is_expected.to respond_with 200 }
    end

    context 'when logged out' do
      before { get :index }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe 'POST create' do
    pending
  end

  describe 'DELETE destroy' do
    context 'when logged in' do
      login!

      context 'when valid id' do
        let!(:campaign)  { create(:campaign) }

        before { delete :destroy, id: campaign.id }

        it { expect(Campaign.count).to be_zero }

        it { is_expected.to redirect_to(campaigns_path) }
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

  describe 'GET chase' do
    pending
  end
end
