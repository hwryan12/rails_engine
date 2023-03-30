class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end 

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.new(item), status: 200
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    render json: { data: { id: item.id, type: "item" } }, status: 204
  end

  private
  def item_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id)
  end
end