require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  describe 'GET All Items' do    
    it 'returns all items' do
      create_list(:item, 10)

      get api_v1_items_path

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(10)
      expect(response).to have_http_status(200)
      expect(response).to have_http_status(:success)

      items[:data].each do |item|
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
  end

  describe 'GET One Item' do    
    context 'when the record exists' do
      it 'returns the item' do
        item = create(:item) 
        
        get api_v1_item_path(item)
        
        item_json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to have_http_status(200)
        expect(response).to have_http_status(:success)
        
        expect(item_json).to have_key(:id)
        expect(item_json[:id]).to be_a(String)
        expect(item_json[:attributes]).to have_key(:name)
        expect(item_json[:attributes][:name]).to be_a(String)
        expect(item_json[:attributes]).to have_key(:description)
        expect(item_json[:attributes][:description]).to be_a(String)
        expect(item_json[:attributes]).to have_key(:unit_price)
        expect(item_json[:attributes][:unit_price]).to be_a(Float)
      end
    end

    context 'when the record does not exist' do
      it 'returns status code 404' do
        item = create(:item)
        get "/api/v1/items/#{item.id + 1}"
    
        expect(response).to have_http_status(404)
        expect(response.body).to include("Couldn't find Item with 'id'=#{item.id + 1}")
      end
    end   
  end
end
