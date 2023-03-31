class Api::V1::MerchantSearchController < ApplicationController
  def show
    @merchant = Merchant.partial_name_search(params[:name]).first
    if @merchant.nil?
      render json: { data: {} }, status: 200
    else
      render json: MerchantSerializer.new(@merchant), status: 200
    end
  end
end