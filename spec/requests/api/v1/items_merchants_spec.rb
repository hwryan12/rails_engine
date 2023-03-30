require 'rails_helper'

RSpec.describe "Item Items API", type: :request do
  describe "GET the Merchant for a Given Item ID" do
    it "returns the merchant the item belongs to" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      
      get "/api/v1/items/#{item.id}/merchant"
      
      expect(response).to have_http_status(200)
      expect(response).to have_http_status(:success)
      
      merchant_json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant_json).to have_key(:id)
      expect(merchant_json[:id]).to be_a(String)
      expect(merchant_json[:attributes]).to have_key(:name)
      expect(merchant_json[:attributes][:name]).to be_a(String)
    end
  end

  # Come back to this for sad path test once core functionality is complete 
end