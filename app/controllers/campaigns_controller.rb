class CampaignsController < ApplicationController
  def index
  end

  def list_upload
    ListImport.create(file: params[:list])

    head :ok
  end
end
