require 'rails_helper'

RSpec.describe ShotsController, type: :controller do
  render_views

  describe 'POST #event_postback' do
    def post_event_postback
      post :event_postback
    end

    it do
      Shot.should_receive(:postback).with({}).once
      post_event_postback
    end

    it do
      post_event_postback
      is_expected.to respond_with 200
    end
  end
end
