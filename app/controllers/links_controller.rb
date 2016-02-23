class LinksController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def show
    @link = Link.find(params[:id]).tap do |link|
      link.shot.touch(:clicked_at)
      link.shot.campaign.increment!(:clicked)
    end

    redirect_to @link.url
  end
end
