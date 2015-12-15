class CampaignsController < ApplicationController
  def index
    respond_with @campaigns = Campaign.order(:name)
  end
end
