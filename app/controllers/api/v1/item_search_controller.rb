class Api::V1::ItemSearchController < ApplicationController
  def index
    @item = Item.partial_name_search(item_params[:name])
    if @item
      render json: ItemSerializer.new(@item), status: 200
    else
      render json: { data: {} }, status: 404
    end
  end

  private
  def item_params
    params.permit(:name)
  end
end