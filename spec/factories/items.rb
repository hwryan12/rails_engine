FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Commerce.price(range: 0..100.0) }
    merchant
  end
end
