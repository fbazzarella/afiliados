class ShotsController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!, only: :sendgrid_postback

  def sendgrid_postback
    Shot.postback(params['_json'])
    head :ok
  end
end
