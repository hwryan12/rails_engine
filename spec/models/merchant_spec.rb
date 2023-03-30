require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
  end

  describe "Class Methods" do
    describe ".partial_name_search" do
      it "returns a list of merchants that match the search params" do
        merchant1 = create(:merchant, name: "Bob's Burgers")
        merchant2 = create(:merchant, name: "Burger King")
        merchant3 = create(:merchant, name: "In-N-Out")

        expect(Merchant.partial_name_search("burger")).to eq([merchant1, merchant2])
        expect(Merchant.partial_name_search("burger")).to_not eq([merchant3])
        
        expect(Merchant.partial_name_search("in")).to eq([merchant2, merchant3])
        expect(Merchant.partial_name_search("in")).to_not eq([merchant1])
      end
    end
  end
end