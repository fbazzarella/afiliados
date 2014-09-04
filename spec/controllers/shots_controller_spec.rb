require 'rails_helper'

RSpec.describe ShotsController, type: :controller do
  render_views

  describe 'POST #sendgrid_postback' do
    def post_sendgrid_postback
      post :sendgrid_postback, '_json' => []
    end

    it do
      Shot.should_receive(:postback).with([]).once
      post_sendgrid_postback
    end

    it do
      post_sendgrid_postback
      is_expected.to respond_with 200
    end
  end
end
