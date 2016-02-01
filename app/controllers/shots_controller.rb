class ShotsController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def event_postback
    Shot.postback(params.except(:controller, :action))
    head :ok
  end

  def opened
    Shot.find(params[:id]).touch(:opened_at)
    send_data open("#{Rails.root}/app/assets/images/transparent.png", "rb").read
  end

  def unsubscribed
    Shot.find(params[:id]).touch(:unsubscribed_at)
    render text: 'Descadastrado com sucesso.'
  end
end
