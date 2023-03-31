class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price, :merchant_id 
  belongs_to :merchant

  def self.price_search(min_price, max_price)
    if min_price.present? && max_price.present?
      self.where(unit_price: min_price..max_price).order(unit_price: :asc)
    elsif min_price.present?
      self.where("unit_price >= ?", min_price).order(unit_price: :asc)
    elsif max_price.present?
      self.where("unit_price <= ?", max_price).order(unit_price: :asc)
    end
  end
end