require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description } 
    it { should validate_presence_of :unit_price } 
    it { should validate_presence_of :merchant_id } 
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe "Class Methods" do
    describe '.price_search' do
      let(:merchant) { create(:merchant) }
  
      before do
        create(:item, name: "Magic Ring", description: "A ring that makes you invisible", unit_price: 1000.00, merchant: merchant)
        create(:item, name: "Ring Pop", description: "A ring that tastes like candy", unit_price: 2.00, merchant: merchant)
        create(:item, name: "Air Fryer", description: "Air fries your food", unit_price: 149.99, merchant: merchant)
        create(:item, name: "Chicken Wings", description: "Fried chicken wings", unit_price: 10.00, merchant: merchant)
      end
  
      context 'when searching by min_price and max_price' do
        it 'returns items with unit prices within the range in ascending order' do
          expect(Item.price_search(3.00, 20.00).pluck(:unit_price)).to eq([10.00])
        end
      end
  
      context 'when searching by min_price only' do
        it 'returns items with unit prices equal or greater than min_price in ascending order' do
          expect(Item.price_search(10.00, nil).pluck(:unit_price)).to eq([10.00, 149.99, 1000.00])
        end
      end
  
      context 'when searching by max_price only' do
        it 'returns items with unit prices equal or less than max_price in ascending order' do
          expect(Item.price_search(nil, 100.00).pluck(:unit_price)).to eq([2.00, 10.00])
        end
      end
    end
  end
end