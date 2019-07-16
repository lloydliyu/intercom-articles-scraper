class Api::V1::ArticlesController < ApplicationController
  
  before_action :prepare_params
  
  def index
    @articles = Article.all
    render json: @articles.to_json
  end
  
  def show
    render json: @article.to_json
  end
  
  def destroy
    render json: @article.destroy.to_json
  end
  
  private def prepare_params
    @article = Article.find(params[:id]) if params[:id].present?
  end
end
