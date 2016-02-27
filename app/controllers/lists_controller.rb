class ListsController < ApplicationController
  def index
    respond_with @lists = List.order(created_at: :desc).page(params[:page]).per(5)
  end

  def create
    render json: List.create(list_params).to_json
  end

  def destroy
    respond_with @list = List.destroy(params[:id]), location: lists_path
  end

  def validate
    ListValidateJob.perform_later(params[:list_id])
    List.find(params[:list_id]).update_attribute(:status, 'Validando')
    redirect_to lists_path
  end

  private

  def list_params
    params.require(:list).permit(:file)
  end
end
