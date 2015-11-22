class CampaignsController < ApplicationController
  def index
  end

  def create
    Email.find_each do |email|
      CampaignMailer.send_campaign(params[:campaign].merge!(to: email.address)).deliver_later
    end

    redirect_to '/sidekiq'
  end
end
