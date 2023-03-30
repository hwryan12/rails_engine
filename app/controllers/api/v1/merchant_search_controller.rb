class Api::V1::MerchantSearchController < ApplicationController
  def show
    @merchant = Merchant.partial_name_search(merchant_params[:name]).first
    if @merchant
      render json: MerchantSerializer.new(@merchant), status: 200
    else
      render json: { data: {} }, status: 404
    end
  end

  private
  def merchant_params
    params.permit(:name)
  end
end