class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
  rescue ActiveRecord::RecordNotFound => error
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end
end