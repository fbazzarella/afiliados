class ShotsController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!, only: :event_postback

  def event_postback
    Shot.postback(params['_json'] || params['items'], params['service'])
    head :ok
  end
end
