class RelaysController < ApplicationController
  def index
    @relays = File.open(CampaignMailer::RELAYS_PATH, "rb").read
  rescue Errno::ENOENT
    write_or_create_and_redirect
  end

  def create
    write_or_create_and_redirect params[:relay][:relays]
  end

  private

  def write_or_create_and_redirect(relays = nil)
    File.open(CampaignMailer::RELAYS_PATH, "wb") { |f| f.write(relays) }
    redirect_to relays_path
  end
end
