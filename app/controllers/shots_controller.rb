class ShotsController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def event_postback
    Shot.postback(params.except(:controller, :action))
    head :ok
  end

  def opened
    Shot.find(params[:id]).tap do |shot|
      shot.touch(:opened_at)
      shot.campaign.increment!(:opened)
    end

    send_data open("#{Rails.root}/app/assets/images/transparent.png", "rb").read
  end

  def unsubscribed
    Shot.find(params[:id]).tap do |shot|
      shot.touch(:unsubscribed_at)
      shot.campaign.increment!(:unsubscribed)
    end

    render text: 'Descadastrado com sucesso.'
  end
end
