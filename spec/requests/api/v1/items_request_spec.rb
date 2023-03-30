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

  describe 'CREATE An Item' do    
    context 'when the params are valid' do
      it 'creates the item' do
        merchant = create(:merchant) 
        item_params = { 
          name: 'New Item', 
          description: 'New Description', 
          unit_price: 100.00, 
          merchant_id: merchant.id 
        }
        
        post api_v1_items_path, params: item_params
        
        new_item = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to have_http_status(201)
        expect(response).to have_http_status(:success)
        
        expect(new_item).to have_key(:id)
        expect(new_item[:id]).to be_a(String)
        expect(new_item[:attributes]).to have_key(:name)
        expect(new_item[:attributes][:name]).to be_a(String)
        expect(new_item[:attributes]).to have_key(:description)
        expect(new_item[:attributes][:description]).to be_a(String)
        expect(new_item[:attributes]).to have_key(:unit_price)
        expect(new_item[:attributes][:unit_price]).to be_a(Float)
      end
    end

    context 'when the params are not valid' do
      it 'does not creates the item' do
        merchant = create(:merchant) 
        item_params = { 
          name: 'New Item',
          description: 'New Description', 
          unit_price: nil, 
          merchant_id: merchant.id 
        }
        
        post api_v1_items_path, params: item_params
        
        expect(response).to have_http_status(422)
        expect(response.body).to include("Unit price can't be blank")
      end
    end
  end

  describe 'EDIT An Item' do
    context 'when the params are valid' do
      it 'updates the item' do
        merchant = create(:merchant) 
        item = create(:item)
        updated_item_params = {
          id: item.id,
          name: 'Updated Item',
          unit_price: 12.34,
          merchant_id: merchant.id 
        }
        # Description is not included in the params, so it should not be updated

        put api_v1_item_path(item), params: updated_item_params

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['attributes']['name']).to eq(updated_item_params[:name])
        expect(JSON.parse(response.body)['data']['attributes']['unit_price']).to eq(updated_item_params[:unit_price])
      end
    end
  
    # Sad Path test for when the update params are not valid, skipped for now

    # context 'when the params are not valid' do
    #   it 'does not update the item' do
    #     item = create(:item)
    #     updated_item_params = { name: nil }

    #     put api_v1_item_path(item), params: updated_item_params
  
    #     expect(response).to have_http_status(404)
    #     expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
    #   end
    # end
  end

  describe 'DELETE An Item' do
    it 'deletes the item' do
      merchant = create(:merchant) 
      item = create(:item)

      delete "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(204)
      expect { item.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
