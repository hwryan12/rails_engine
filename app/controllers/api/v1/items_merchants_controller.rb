class Api::V1::ItemsMerchantsController < ApplicationController
  def show
    item = Item.find(params[:item_id])
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant), status: 200
  end
end