class CampaignsController < ApplicationController
  def index
  end

  def list_upload
    uploaded_file = params[:list]
    lists_path    = File.join(Rails.root, '/tmp/lists/')
    file_path     = File.join(lists_path, uploaded_file.original_filename)

    FileUtils.mkdir_p(lists_path)
    File.open(file_path, 'wb') { |f| f.write(uploaded_file.read) }

    head :ok
  end
end
