require 'rails_helper'

RSpec.describe ShotsController, type: :controller do
  render_views

  describe 'POST #event_postback' do
    context 'when service is sendgrid' do
      def post_event_postback
        post :event_postback, '_json' => [], 'service' => 'sendgrid'
      end

      it do
        Shot.should_receive(:postback).with([], 'sendgrid').once
        post_event_postback
      end

      it do
        post_event_postback
        is_expected.to respond_with 200
      end
    end

    context 'when service is mailgun' do
      def post_event_postback
        post :event_postback, 'items' => [], 'service' => 'mailgun'
      end

      it do
        Shot.should_receive(:postback).with([], 'mailgun').once
        post_event_postback
      end

      it do
        post_event_postback
        is_expected.to respond_with 200
      end
    end
  end
end
