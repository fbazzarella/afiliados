class CampaignsController < ApplicationController
  def index
    respond_with @campaigns = Campaign.order(:name)
  end

  def create
    respond_with @campaign = Campaign.create(campaign_params).prepare_chase!(list_ids), location: campaigns_path
  end

  def chase
    Campaign.find(params[:campaign_id]).chase!
    redirect_to campaigns_path
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :newsletter_id)
  end

  def list_ids
    params[:campaign][:list_id].reject { |e| e.empty? }
  end
end
