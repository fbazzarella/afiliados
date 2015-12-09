class ListsController < ApplicationController
  def index
  end

  def create
    ListImport.create(file: params[:list])
    head :ok
  end
end
