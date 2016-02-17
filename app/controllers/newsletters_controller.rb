class NewslettersController < ApplicationController
  def index
    respond_with @newsletters = Newsletter.order(:subject).page(params[:page]).per(5)
  end

  def create
    respond_with @newsletter = Newsletter.create(newsletter_params), location: newsletters_path
  end

  def destroy
    respond_with @nresletter = Newsletter.destroy(params[:id]), location: newsletters_path
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:from, :subject, :body)
  end
end
