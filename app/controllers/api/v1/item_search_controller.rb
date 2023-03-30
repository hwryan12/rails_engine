class Api::V1::ItemSearchController < ApplicationController
  def index
    if item_params[:name].present? && (item_params[:min_price].present? || item_params[:max_price].present?)
      render json: { error: "Name and price parameters cannot be sent together" }, status: :bad_request
    elsif item_params[:name].present?
      @items = Item.partial_name_search(item_params[:name])
      render json: ItemSerializer.new(@items), status: 200
    elsif item_params[:min_price].present? || item_params[:max_price].present?
      @items = Item.price_search(item_params[:min_price], item_params[:max_price])
      render json: ItemSerializer.new(@items), status: 200
    else
      render json: { data: {} }, status: 404
    end
  end

  private
  def item_params
    params.permit(:name, :min_price, :max_price)
  end
end