class ListsController < ApplicationController
  def index
  end

  def create
    List.create(file: params[:list])
    head :ok
  end
end
