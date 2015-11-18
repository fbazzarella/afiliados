class CampaignsController < ApplicationController
  def index
  end

  def list_upload
    ListHandler.new(params[:list]).save_to_disk_and_import!

    head :ok
  end
end
