require 'rails_helper'

RSpec.describe 'Merchants API', type: :request do
  describe 'GET /api/v1/merchants' do
    before { FactoryBot.create_list(:merchant, 10) }

    it 'returns all merchants' do
      get '/api/v1/merchants'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(10)
    end
  end
end
