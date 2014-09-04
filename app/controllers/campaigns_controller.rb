class CampaignsController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!, only: :sendgrid_postback

  def index
  end

  def sendgrid_postback
    Campaign.postback(params['_json'])

    head :ok
  end
end
