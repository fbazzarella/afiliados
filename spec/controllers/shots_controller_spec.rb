require 'rails_helper'

RSpec.describe ShotsController, type: :controller do
  render_views

  describe 'POST event_postback' do
    def post_event_postback
      post :event_postback
    end

    it do
      expect(Shot).to receive(:postback).with({}).once
      post_event_postback
    end

    it do
      post_event_postback
      is_expected.to respond_with 200
    end
  end

  describe 'GET opened' do
    pending
  end

  describe 'GET unsubscribed' do
    pending
  end
end
