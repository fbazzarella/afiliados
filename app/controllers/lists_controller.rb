class ListsController < ApplicationController
  def index
    @lists = List.order(:name)
  end

  def create
    render json: List.create(list_params).to_json
  end

  private

  def list_params
    params.require(:list).permit(:file)
  end
end
