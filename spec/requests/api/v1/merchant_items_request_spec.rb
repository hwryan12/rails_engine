require 'rails_helper'

RSpec.describe "Merchant Items API", type: :request do
  describe "GET All Items for a Given Merchant ID" do
    it "returns all items belonging to the merchant" do
      merchant = create(:merchant)
      create_list(:item, 10, merchant: merchant)

      get api_v1_merchant_items_path(merchant)
      
      expect(response).to have_http_status(200)
      expect(response).to have_http_status(:success)
      
      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(10)
      
      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end


    it "returns an error when trying to get items for a non-existent merchant ID" do
      get api_v1_merchant_items_path(999999) #a random merchant ID

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=999999")
    end
  end
end
