require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  render_views

  describe 'GET #index' do
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

  describe 'POST #sendgrid_postback' do
    before { post :sendgrid_postback }

    it do
      Campaign.should_receive(:postback).with([]).once
      post :sendgrid_postback, '_json' => []
    end

    it { is_expected.to respond_with 200 }
  end
end
