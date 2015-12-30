class ListsController < ApplicationController
  def index
    respond_with @lists = List.order(:name)
  end

  def create
    render json: List.create(list_params).to_json
  end

  def destroy
    respond_with @list = List.destroy(params[:id]), location: lists_path
  end

  def download
    send_data List.find(params[:list_id]).to_csv
  end

  private

  def list_params
    params.require(:list).permit(:file)
  end
end
