require 'rails_helper'

RSpec.describe 'Merchants API', type: :request do
  describe 'GET All Merchants' do    
    it 'returns all merchants' do
      create_list(:merchant, 10) 
      
      get api_v1_merchants_path

      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchants[:data].count).to eq(10)
      
      expect(response).to have_http_status(200)
      expect(response).to have_http_status(:success)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe 'GET One Merchant' do    
    context 'when the record exists' do
      it 'returns the merchant' do
        merchant = create(:merchant) 
        
        get api_v1_merchant_path(merchant)
        
        merchant_json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to have_http_status(200)
        expect(response).to have_http_status(:success)
        
        expect(merchant_json).to have_key(:id)
        expect(merchant_json[:id]).to be_a(String)
        expect(merchant_json[:attributes]).to have_key(:name)
        expect(merchant_json[:attributes][:name]).to be_a(String)
      end
    end

    context 'when the record does not exist' do
      it 'returns status code 404' do
        merchant = create(:merchant)
        get "/api/v1/merchants/#{merchant.id + 1}"
    
        expect(response).to have_http_status(404)
        expect(response.body).to include("Couldn't find Merchant with 'id'=#{merchant.id + 1}")
      end
    end
    
  end
end
